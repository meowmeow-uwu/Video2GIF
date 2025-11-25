<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DUT - Video2GIF - Trang chủ</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        background-color: #f9f9f9;
    }

    .header {
        display: flex;
        justify-content: flex-end; 
        padding: 20px;
        background-color: #fff;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .btn {
        text-decoration: none;
        padding: 10px 20px;
        margin-left: 10px;
        border: 1px solid #333;
        color: #333;
        border-radius: 4px;
        font-weight: bold;
        transition: 0.3s;
    }

    .btn:hover {
        background-color: #333;
        color: #fff;
    }

    /* Pháº§n tiÃªu Äá» chÃ­nh */
    .main-title {
        text-align: center;
        margin-top: 40px;
        margin-bottom: 30px;
        font-size: 28px;
        font-weight: bold;
    }

    .gallery-container {
        max-width: 1000px;
        margin: 0 auto;
        padding: 20px;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px; 
    }

    .gallery-item {
        border: 1px solid #ccc;
        background-color: #fff;
        padding: 15px;
        text-align: center;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }

    .gallery-item img {
        max-width: 100%; /* áº¢nh co giÃ£n theo khung */
        height: auto;
        display: block;
        margin: 0 auto 0px auto;
        border-radius: 4px;
    }

    .gallery-item p {
        margin: 0;
        color: #555;
        font-size: 14px;
    }
</style>
</head>
<body>

    <div class="header">
        <a href="LoginServlet" class="btn">Đăng nhập</a>
        <a href="RegisterServlet" class="btn">Đăng ký</a>
    </div>

    <h1 class="main-title">Trang chủ</h1>

    <div class="gallery-container">
        
        <div class="gallery-item">
            <img src="https://placehold.co/300x200/F06292/ffffff?text=Demo+GIF+1" alt="Demo 1" onerror="this.onerror=null;this.src='https://placehold.co/300x200/F06292/ffffff?text=Demo+GIF+1';">
        </div>

        <div class="gallery-item">
            <img src="https://placehold.co/300x200/4FC3F7/ffffff?text=Demo+GIF+2" alt="Demo 2" onerror="this.onerror=null;this.src='https://placehold.co/300x200/4FC3F7/ffffff?text=Demo+GIF+2';">
        </div>

        <div class="gallery-item">
            <img src="https://placehold.co/300x200/81C784/ffffff?text=Demo+GIF+3" alt="Demo 3" onerror="this.onerror=null;this.src='https://placehold.co/300x200/81C784/ffffff?text=Demo+GIF+3';">
        </div>

        <div class="gallery-item">
            <img src="https://placehold.co/300x200/FFB74D/ffffff?text=Demo+GIF+4" alt="Demo 4" onerror="this.onerror=null;this.src='https://placehold.co/300x200/FFB74D/ffffff?text=Demo+GIF+4';">
        </div>

        <div class="gallery-item">
            <img src="https://placehold.co/300x200/BA68C8/ffffff?text=Demo+GIF+5" alt="Demo 5" onerror="this.onerror=null;this.src='https://placehold.co/300x200/BA68C8/ffffff?text=Demo+GIF+5';">
        </div>

        <div class="gallery-item">
            <img src="https://placehold.co/300x200/90A4AE/ffffff?text=Demo+GIF+6" alt="Demo 6" onerror="this.onerror=null;this.src='https://placehold.co/300x200/90A4AE/ffffff?text=Demo+GIF+6';">
        </div>

    </div>
</body>
</html>