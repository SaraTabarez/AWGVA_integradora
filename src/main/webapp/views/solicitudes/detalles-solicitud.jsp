<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalles de la Solicitud - UTEZ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Menú Lateral -->
<div class="sidebar">
    <div style="text-align: center; margin-bottom: 20px;">
        <div style="width: 60px; height: 60px; border-radius: 50%; background: #ccc; margin: 0 auto 10px auto;"></div>
        <h3>Nombre Usuario</h3>
    </div>
    <hr>
    <a href="#">🏠 Inicio</a>
    <a href="#" style="background: rgba(255,255,255,0.1); font-weight: bold;">📄 Solicitudes</a>
    <a href="#">📜 Histórico</a>
    <a href="#">👥 Usuarios</a>
    <a href="#">✍️ Firmas</a>
    <br><br>
    <a href="#">🚪 Cerrar sesión</a>
</div>

<!-- Contenido Principal -->
<div class="main-content">
    <h2 class="title">Solicitud #SOL-2026-089</h2>

    <!-- Stepper / Barra de Estado -->
    <div class="stepper-wrapper">
        <div class="stepper-item completed">
            <div class="step-counter">1</div>
            <div class="step-name">Enviada</div>
        </div>
        <div class="stepper-item completed">
            <div class="step-counter">2</div>
            <div class="step-name">En Revisión</div>
        </div>
        <div class="stepper-item active">
            <div class="step-counter">3</div>
            <div class="step-name">Firmas</div>
        </div>
        <div class="stepper-item">
            <div class="step-counter">4</div>
            <div class="step-name">Aprobada</div>
        </div>
    </div>

    <!-- Paneles de Detalles -->
    <div class="details-grid">

        <!-- Panel Izquierdo: Datos de la solicitud -->
        <div class="card-panel">
            <h3>Información General</h3>

            <div class="field-group">
                <label>Solicitante:</label>
                <span>Prof. Roberto Carlos Ruiz</span>
            </div>

            <div class="field-group">
                <label>Asunto:</label>
                <span>Solicitud de equipo de cómputo para laboratorio</span>
            </div>

            <div class="field-group">
                <label>Descripción / Justificación:</label>
                <span>Se requiere la adquisición de 5 computadoras para el área de desarrollo de software debido a la actualización del plan de estudios.</span>
            </div>

            <div class="field-group">
                <label>Documento Adjunto:</label>
                <span><a href="#" style="color: #002b49; font-weight: bold;">📎 especificaciones_tecnicas.pdf</a></span>
            </div>
        </div>

        <!-- Panel Derecho: Acciones y Estado -->
        <div class="card-panel">
            <h3>Acciones del Revisión</h3>

            <div class="field-group">
                <label>Estado Actual:</label>
                <span class="badge badge-pending">Pendiente de Firma</span>
            </div>

            <div class="field-group">
                <label>Fecha de Creación:</label>
                <span>26 de Julio, 2026</span>
            </div>

            <hr style="margin: 20px 0;">

            <div style="display: flex; flex-direction: column; gap: 10px;">
                <button class="btn btn-success">Aprobar y Firmar</button>
                <button class="btn btn-danger">Rechazar Solicitud</button>
                <button class="btn btn-secondary">Regresar</button>
            </div>
        </div>

    </div>
</div>

</body>
</html>