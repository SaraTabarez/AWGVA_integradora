<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mx.edu.utez.awgva.Model.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio - Sistema de Gestión de Visitas Académicas</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7fafc;
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, #1a365d 0%, #2c5282 100%);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .logo {
            font-size: 32px;
            font-weight: bold;
            letter-spacing: 3px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-name {
            font-size: 16px;
        }

        .btn-logout {
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s;
        }

        .btn-logout:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        /* Contenido principal */
        .main-content {
            padding: 60px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .welcome-section {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        .welcome-title {
            font-size: 28px;
            color: #1a365d;
            margin-bottom: 10px;
        }

        .welcome-text {
            color: #718096;
            font-size: 16px;
        }

        /* Cards de funcionalidades */
        .cards-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .card-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .card-title {
            font-size: 20px;
            color: #1a365d;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .card-description {
            color: #718096;
            font-size: 14px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
<!-- Header -->
<div class="header">
    <div class="logo">AWGVA</div>
    <div class="user-info">
        <%
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            String nombreUsuario = (String) session.getAttribute("nombreUsuario");
            if (nombreUsuario == null && usuario != null) {
                nombreUsuario = usuario.getNombreCompleto();
            }
        %>
        <span class="user-name">
                Bienvenido, <%= nombreUsuario != null ? nombreUsuario : "Usuario" %>
            </span>
        <form action="logout" method="POST" style="display: inline;">
            <button type="submit" class="btn-logout">Cerrar Sesión</button>
        </form>
    </div>
</div>

<!-- Contenido principal -->
<div class="main-content">
    <div class="welcome-section">
        <h1 class="welcome-title">Sistema de Gestión de Visitas Académicas</h1>
        <p class="welcome-text">
            Bienvenido al sistema de gestión de visitas académicas de la UTEZ.
            Desde aquí podrás administrar las solicitudes de visitas, gestionar usuarios
            y dar seguimiento a los formatos de visitas académicas.
        </p>
    </div>

    <div class="cards-container">
        <div class="card">
            <div class="card-icon">📋</div>
            <h3 class="card-title">Solicitudes de Visita</h3>
            <p class="card-description">
                Gestiona las solicitudes de visitas académicas. Crea, aprueba o rechaza
                solicitudes de visita a empresas.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">👥</div>
            <h3 class="card-title">Gestión de Usuarios</h3>
            <p class="card-description">
                Administra los usuarios del sistema. Asigna roles y permisos según
                las necesidades de cada división.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">🏢</div>
            <h3 class="card-title">Empresas</h3>
            <p class="card-description">
                Mantén el catálogo de empresas visitadas. Registra la información
                de contacto y detalles de cada empresa.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">📊</div>
            <h3 class="card-title">Reportes</h3>
            <p class="card-description">
                Consulta reportes y estadísticas sobre las visitas académicas
                realizadas y su estado actual.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">📁</div>
            <h3 class="card-title">Documentos</h3>
            <p class="card-description">
                Gestiona los documentos relacionados con las visitas académicas.
                Sube y descarga formatos y archivos.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">⚙️</div>
            <h3 class="card-title">Configuración</h3>
            <p class="card-description">
                Configura los parámetros del sistema. Define divisiones, roles
                y otras configuraciones generales.
            </p>
        </div>
    </div>
</div>
</body>
</html>