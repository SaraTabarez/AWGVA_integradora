<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 04/08/2026
  Time: 08:39 a. m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Reporte rechazado</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="portal-main">
    <section class="result-box">
        <div class="result-icon no"><i class="bi bi-x-lg"></i></div>
        <h1 class="page-title">Reporte rechazado</h1>
        <p class="page-subtitle mb-4">Las observaciones quedaron disponibles para el docente. La visita aún no se marca como completada.</p>
        <a class="btn-orange" href="${ctx}/estadias/documento?id=${visitaId}">Volver a la visita</a>
    </section>
</main>
</body>
</html>