<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mx.edu.utez.awgva.Model.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #ffffff;
            min-height: 100vh;
        }

        /* Espaciado para dar lugar al sidebar fijo (240px) */
        .main-layout {
            margin-left: 240px;
            padding: 3rem 3.5rem;
            min-height: 100vh;
            background-color: #ffffff;
        }

        /* Encabezado superior */
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 2.5rem;
        }

        .page-title {
            color: #1e3a5f;
            font-size: 2rem;
            font-weight: 800;
            margin: 0;
            line-height: 1.1;
        }

        .page-subtitle {
            color: #f38218;
            font-size: 1.25rem;
            font-weight: 700;
            margin-top: 0.5rem;
        }

        /* Botón Nueva Solicitud */
        .btn-new-request {
            background-color: #f38218;
            color: #ffffff;
            border: none;
            border-radius: 6px;
            padding: 0.6rem 1.6rem;
            font-weight: 600;
            font-size: 0.95rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 2px 4px rgba(243, 130, 24, 0.2);
            transition: background-color 0.2s ease, transform 0.1s ease;
        }

        .btn-new-request:hover {
            background-color: #d9700f;
            color: #ffffff;
        }

        /* Grid de Tarjetas de Solicitud */
        .requests-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 320px));
            gap: 2rem;
        }

        /* Estilo de la tarjeta de la visita */
        .request-card {
            border: 1px solid #d1d5db;
            border-radius: 12px;
            padding: 12px;
            background-color: #ffffff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: box-shadow 0.2s ease;
        }

        .request-card:hover {
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
        }

        .request-card .card-img {
            width: 100%;
            height: 140px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 12px;
        }

        .request-card .card-company {
            color: #1e3a5f;
            font-weight: 700;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 12px;
        }

        .request-card .card-footer-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 8px;
        }

        .request-card .card-id {
            color: #94a3b8;
            font-size: 0.85rem;
            font-weight: 500;
        }

        /* Botón Detalles */
        .btn-details {
            border: 1px solid #f38218;
            color: #f38218;
            background-color: transparent;
            border-radius: 6px;
            padding: 0.35rem 1.2rem;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .btn-details:hover {
            background-color: #f38218;
            color: #ffffff;
        }
    </style>
</head>
<body>

<%
    // Lógica para rescatar la sesión guardada
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    if (nombreUsuario == null && usuario != null) {
        nombreUsuario = usuario.getNombreCompleto();
    }
%>

<!-- Inclusión de tu Sidebar dinámico -->
<jsp:include page="Layout/sidebar.jsp"/>

<!-- Contenido Principal -->
<main class="main-layout">

    <!-- Encabezado con título y botón de acción -->
    <div class="top-header">
        <div>
            <h1 class="page-title">Inicio</h1>
            <div class="page-subtitle">Mis solicitudes</div>
        </div>
        <div>
            <a href="nueva-solicitud.jsp" class="btn-new-request">
                <i class="bi bi-plus-circle"></i>
                Nueva solicitud
            </a>
        </div>
    </div>

    <!-- Contenedor/Grid con las tarjetas de solicitudes -->
    <div class="requests-grid">

        <!-- Tarjeta de Ejemplo (Nissan, Cuernavaca) -->
        <div class="request-card">
            <!-- Foto de la empresa -->
            <img src="https://images.unsplash.com/photo-1563720223185-11003d516935?q=80&w=600&auto=format&fit=crop" alt="Nissan" class="card-img">

            <div class="card-company">
                Nissan, Cuernavaca <i class="bi bi-geo-alt" style="font-size: 0.95rem; color: #1e3a5f;"></i>
            </div>

            <div class="card-footer-info">
                <span class="card-id">ID:001</span>
                <a href="#" class="btn-details">
                    <i class="bi bi-eye"></i> Detalles
                </a>
            </div>
        </div>

    </div>

</main>

</body>
</html>