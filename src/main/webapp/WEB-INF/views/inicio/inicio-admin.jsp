<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio Administración - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/role-home.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/Layout/sidebar.jsp"/>
<main class="role-home">
    <header class="role-header">
        <div><div class="role-eyebrow">Administración del sistema</div><h1 class="role-title">Control general de AWGVA</h1><p class="role-subtitle">ADMIN dispone de acceso integral a los módulos y a la configuración de usuarios.</p></div>
        <span class="role-badge">ADMIN</span>
    </header>
    <section class="action-grid" aria-label="Acciones de Administración">
        <a class="action-card" href="${ctx}/GestionUsuariosServlet"><span class="action-icon"><i class="bi bi-people"></i></span><h2>Gestionar usuarios</h2><p>Consulta cuentas, roles, divisiones y estado de acceso.</p></a>
        <a class="action-card" href="${ctx}/RegistrarUsuarioServlet"><span class="action-icon"><i class="bi bi-person-plus"></i></span><h2>Registrar usuario</h2><p>Crea cuentas con un rol y una división válidos obtenidos de Oracle.</p></a>
        <a class="action-card" href="${ctx}/servlet-gestion-solicitudes"><span class="action-icon"><i class="bi bi-clipboard-check"></i></span><h2>Solicitudes</h2><p>Accede al módulo de revisión utilizado por Dirección.</p></a>
        <a class="action-card" href="${ctx}/gestion-documentos.jsp"><span class="action-icon"><i class="bi bi-folder-check"></i></span><h2>Documentos</h2><p>Accede al control documental correspondiente a Estadías.</p></a>
        <a class="action-card" href="${ctx}/revisar-reporte.jsp"><span class="action-icon"><i class="bi bi-journal-check"></i></span><h2>Reportes</h2><p>Supervisa la revisión y resolución de reportes de visita.</p></a>
        <a class="action-card" href="${ctx}/solicitud.jsp"><span class="action-icon"><i class="bi bi-file-earmark-text"></i></span><h2>Vista docente</h2><p>Accede al flujo operativo de solicitudes de los docentes.</p></a>
    </section>
    <div class="summary-strip"><i class="bi bi-exclamation-triangle"></i><span>Usa la cuenta ADMIN sólo para tareas administrativas y cambia la contraseña inicial después de crearla.</span></div>
</main>
</body>
</html>

//a ver si ya