package worker;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import model.Bean.TaskData;

class WorkerResponse implements Serializable {
    private static final long serialVersionUID = 1L;
    public int requestId;
    public String status; 
    public String gifPath; 
    public String errorMessage;

    public WorkerResponse(int requestId, String status, String gifPath, String errorMessage) {
        this.requestId = requestId;
        this.status = status;
        this.gifPath = gifPath;
        this.errorMessage = errorMessage;
    }
}


public class VideoWorker implements Runnable {

    private static final int SERVER_PORT = 9999;           
    private static final String SERVER_HOST = "localhost";
    private static final int COMPLETION_PORT = 9998;       

    private static final int THREAD_POOL_SIZE = 4;
    private final ExecutorService taskPool = Executors.newFixedThreadPool(THREAD_POOL_SIZE);

    private static String WEB_APP_ROOT = "C:/Users/Danh/Desktop/Java/LTMProject/DUT-Video2GIF/webapp/"; 
    

	public VideoWorker() {
	}

	public static void main(String[] args) {
        if (args.length > 0) {
            WEB_APP_ROOT = args[0]; 
        }
        if (!WEB_APP_ROOT.endsWith(File.separator)) {
            WEB_APP_ROOT += File.separator;
        }
        System.out.println("--- VideoWorker khởi động. Thư mục gốc Web App: " + WEB_APP_ROOT + " ---");
        new VideoWorker().run();
    }

    @Override
    public void run() {
        System.out.println("Worker lắng nghe các Task mới từ Server tại cổng " + SERVER_PORT + "...");
        try (ServerSocket serverSocket = new ServerSocket(SERVER_PORT)) {
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    Socket clientSocket = serverSocket.accept();
                    taskPool.submit(new TaskProcessor(clientSocket));
                } catch (IOException e) {
                    if (!serverSocket.isClosed()) {
                        System.err.println("Lỗi chấp nhận kết nối TCP: " + e.getMessage());
                    }
                    break;
                }
            }
        } catch (IOException e) {
            System.err.println("Không thể khởi tạo Server Socket cho Worker: " + e.getMessage());
        } finally {
            taskPool.shutdown();
            try {
                taskPool.awaitTermination(60, TimeUnit.SECONDS);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            System.out.println("--- Worker Thread Pool đã dừng ---");
        }
    }

    // Lớp nội bộ xử lý từng Task chuyển đổi video
    private class TaskProcessor implements Runnable {
        private Socket clientSocket;

        public TaskProcessor(Socket socket) {
            this.clientSocket = socket;
        }

        @Override
        public void run() {
            TaskData task = null;
            String errorMessage = null;

            try (ObjectInputStream ois = new ObjectInputStream(clientSocket.getInputStream())) {
                
                // 1. Nhận Task từ Server
                task = (TaskData) ois.readObject();
                System.out.println("Worker Thread #" + Thread.currentThread().getId() + " nhận Task: " + task.getRequestId());

                // 2. Xử lý chuyển đổi video (Sử dụng FFmpeg)
                // CHÚ Ý: task.getVideoPath() là đường dẫn tương đối (ví dụ: uploaded_videos/user_123.mp4)
                String inputPath = WEB_APP_ROOT + task.getVideoPath().replace("/", File.separator);
                
                File inputFile = new File(inputPath);
                if (!inputFile.exists()) {
                    errorMessage = "Lỗi: Không tìm thấy file video gốc tại " + inputPath;
                    throw new IOException(errorMessage);
                }

                String gifDir = "converted_gifs";
                String outputDir = WEB_APP_ROOT + gifDir;
                
                File dir = new File(outputDir);
                if (!dir.exists()) dir.mkdirs();
                
                String outputFileName = "gif_" + task.getRequestId() + ".gif";
                String outputPath = outputDir + File.separator + outputFileName;
                String relativeGifPath = gifDir + "/" + outputFileName; // Lưu DB dưới dạng "/"

                // Tính toán duration
                String duration = calculateDuration(task.getStartTime(), task.getEndTime());
                
                ProcessBuilder pb = new ProcessBuilder(
                    "ffmpeg", 
                    "-i", inputPath,
                    "-ss", task.getStartTime(),
                    "-t", duration,
                    "-vf", "fps=10,scale=320:-1:flags=lanczos",
                    outputPath
                );
                
                pb.redirectErrorStream(true);
                Process process = pb.start();
                
                // Đọc output FFmpeg để lấy log lỗi chi tiết
                StringBuilder output = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                    String line;
                    while ((line = reader.readLine()) != null) { 
                        output.append(line).append("\n");
                    }
                }
                
                int exitCode = process.waitFor();
                
                if (exitCode == 0) {
                    // 3. Gửi thông báo Hoàn thành về Server
                    sendCompletionNotification(task.getRequestId(), "COMPLETED", relativeGifPath, null);
                } else {
                    // BỔ SUNG: Ghi log lỗi chi tiết
                    errorMessage = "Lỗi FFmpeg (Exit Code: " + exitCode + "): " + output.toString().substring(0, Math.min(output.length(), 200));
                    System.err.println(errorMessage);
                    sendCompletionNotification(task.getRequestId(), "FAILED", null, errorMessage);
                }

            } catch (Exception e) {
                // Xử lý lỗi trong quá trình thực thi Task
                if (errorMessage == null) {
                    errorMessage = "Lỗi nội bộ Worker: " + e.getMessage();
                }
                System.err.println("Lỗi xử lý Task #" + (task != null ? task.getRequestId() : "N/A") + ": " + errorMessage);
                sendCompletionNotification(task != null ? task.getRequestId() : -1, "FAILED", null, errorMessage);
            } finally {
                try { clientSocket.close(); } catch (IOException e) { /* ignore */ }
            }
        }
        
        // Tính toán duration (thời gian) từ start_time và end_time
        private String calculateDuration(String start, String end) {
            // Giả định format MM:SS
            String[] startParts = start.split(":");
            String[] endParts = end.split(":");
            
            long startSeconds = Integer.parseInt(startParts[0]) * 60 + Integer.parseInt(startParts[1]);
            long endSeconds = Integer.parseInt(endParts[0]) * 60 + Integer.parseInt(endParts[1]);
            
            long duration = endSeconds - startSeconds;
            if (duration <= 0) duration = 1; 
            
            // FFmpeg cần duration ở format HH:MM:SS.ms (hoặc HH:MM:SS)
            long minutes = duration / 60;
            long seconds = duration % 60;
            
            return String.format("%02d:%02d", minutes, seconds); // Trả về MM:SS
        }
    }
    
    // Gửi phản hồi hoàn thành Task về Server TCP Listener
    private void sendCompletionNotification(int requestId, String status, String gifPath, String errorMessage) {
        if (requestId == -1) return; 

        try (Socket socket = new Socket(SERVER_HOST, COMPLETION_PORT);
             ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream())) {
            
            // SỬA LỖI: Gửi đối tượng WorkerResponse thay vì VideoWorker
            WorkerResponse response = new WorkerResponse(requestId, status, gifPath, errorMessage);
            oos.writeObject(response);
            oos.flush();
            System.out.println("--- Worker gửi phản hồi cho Request #" + requestId + ": " + status + " ---");

        } catch (IOException e) {
            System.err.println("Không thể gửi thông báo hoàn thành Task #" + requestId + " về Server: " + e.getMessage());
        }
    }
}