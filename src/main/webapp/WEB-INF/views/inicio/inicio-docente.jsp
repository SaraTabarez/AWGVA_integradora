<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio Docente - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css?v=20260804-figma2" rel="stylesheet">
</head>
<body class="docente-figma">
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="docente-main">
    <header class="docente-topbar">
        <div>
            <h1 class="docente-page-title">Inicio</h1>
            <p class="docente-page-subtitle">Panel para crear solicitudes.</p>
        </div>
        <a class="figma-orange-button" href="${ctx}/nueva-solicitud">
            <i class="bi bi-plus-circle"></i> Nueva solicitud
        </a>
    </header>

    <section class="docente-blank-state" aria-label="Inicio del docente">
        <span class="visually-hidden">
            Tienes <c:out value="${requestScope.totalSolicitudes}"/> solicitudes registradas.
        </span>
    </section>
</main>
</body>
</html>