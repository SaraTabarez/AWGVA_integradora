<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .sidebar {
        width: 250px;
        background-color: #2c3e50;
        color: white;
        padding: 20px;
        height: 100vh;
        position: fixed;
        left: 0;
        top: 0;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        z-index: 1000;
        margin: 0;
        box-shadow: 2px 0 5px rgba(0,0,0,0.1);
    }
    .sidebar .user-profile {
        text-align: center;
        margin-bottom: 30px;
    }
    .sidebar .user-profile .avatar {
        width: 80px;
        height: 80px;
        background-color: #34495e;
        border-radius: 50%;
        margin: 0 auto 10px auto;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 40px;
    }
    .sidebar .user-profile .username {
        font-weight: bold;
        font-size: 1.1em;
    }
    .sidebar nav ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .sidebar nav ul li {
        margin-bottom: 15px;
    }
    .sidebar nav ul li a {
        color: white;
        text-decoration: none;
        display: flex;
        align-items: center;
        padding: 12px 15px;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }
    .sidebar nav ul li a i {
        margin-right: 10px;
        font-size: 1.2em;
        width: 20px;
        text-align: center;
    }
    .sidebar nav ul li a:hover,
    .sidebar nav ul li a.active {
        background-color: #3498db;
    }
    .sidebar .logout {
        margin-top: auto;
    }
    .sidebar .logout a {
        color: white;
        text-decoration: none;
        display: flex;
        align-items: center;
        padding: 12px 15px;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }
    .sidebar .logout a:hover {
        background-color: #e74c3c;
    }
    .sidebar .logout a i {
        margin-right: 10px;
        font-size: 1.2em;
        width: 20px;
        text-align: center;
    }
</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<div class="sidebar">
    <div>
        <div class="user-profile">
            <div class="avatar">
                <i class="fas fa-user"></i>
            </div>
            <div class="username">DOCENTE</div>
        </div>
        <nav>
            <ul>
                <li>
                    <a href="index.jsp" class="${pageContext.request.requestURI.endsWith('index.jsp') ? 'active' : ''}">
                        <i class="fas fa-home"></i>
                        Inicio
                    </a>
                </li>
                <li>
                    <a href="nueva-solicitud.jsp" class="${pageContext.request.requestURI.endsWith('nueva-solicitud.jsp') ? 'active' : ''}">
                        <i class="fas fa-file-alt"></i>
                        Solicitud
                    </a>
                </li>
                <li>
                    <a href="subir-docs.jsp" class="${pageContext.request.requestURI.endsWith('subir-docs.jsp') ? 'active' : ''}">
                        <i class="fas fa-upload"></i>
                        Reporte
                    </a>
                </li>
                <li>
                    <a href="#" class="${pageContext.request.requestURI.endsWith('historico.jsp') ? 'active' : ''}">
                        <i class="fas fa-history"></i>
                        Histórico
                    </a>
                </li>
            </ul>
        </nav>
    </div>
    <div class="logout">
        <a href="logout">
            <i class="fas fa-sign-out-alt"></i>
            Cerrar Sesión
        </a>
    </div>
</div>