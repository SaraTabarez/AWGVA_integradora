<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Reportes enviados - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css?v=20260804-figma2" rel="stylesheet">
</head>
<body class="docente-figma">
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="docente-main">
    <header class="docente-topbar">
        <div>
            <h1 class="docente-page-title">Reporte</h1>
            <p class="docente-page-subtitle">Reportes enviados.</p>
        </div>
        <a class="figma-orange-button" href="${ctx}/nueva-solicitud">
            <i class="bi bi-plus-circle"></i> Nueva solicitud
        </a>
    </header>

    <c:choose>
        <c:when test="${empty solicitudes}">
            <div class="docente-empty"><i class="bi bi-folder2-open me-2"></i>Aún no has enviado reportes.</div>
        </c:when>
        <c:otherwise>
            <section class="figma-card-grid" aria-label="Reportes enviados">
                <c:forEach var="item" items="${solicitudes}">
                    <article class="figma-visit-card">
                        <div class="figma-company-cover">
                            <i class="bi bi-camera"></i>
                            <strong><c:out value="${item.empresa}"/></strong>
                        </div>
                        <div class="figma-card-location">
                            <span><c:out value="${item.empresa}"/>, <c:out value="${item.direccionEmpresa}"/></span>
                            <i class="bi bi-geo-alt"></i>
                        </div>
                        <div class="figma-card-status">Reporte <c:out value="${item.estadoReporte}"/></div>
                        <div class="figma-card-footer">
                            <span class="figma-card-id">ID: <c:out value="${item.idVisita}"/></span>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>