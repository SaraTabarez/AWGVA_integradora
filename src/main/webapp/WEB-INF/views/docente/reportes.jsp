<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 04/08/2026
  Time: 08:37 a. m.
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
    <title>Reportes enviados - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="portal-main">
    <header class="page-top">
        <div>
            <div class="eyebrow">Panel docente</div>
            <h1 class="page-title">Visitas con reporte enviado</h1>
            <p class="page-subtitle">Esta pantalla conserva únicamente la tarjeta del reporte; se quitaron documentos y botones adicionales.</p>
        </div>
    </header>

    <c:choose>
        <c:when test="${empty solicitudes}">
            <section class="panel empty">
                <i class="bi bi-cloud-slash"></i>Aún no has enviado reportes.
            </section>
        </c:when>
        <c:otherwise>
            <section class="report-grid">
                <c:forEach var="item" items="${solicitudes}">
                    <article class="report-card">
                        <div class="eyebrow">ID #<c:out value="${item.idVisita}"/></div>
                        <h3><c:out value="${item.empresa}"/></h3>
                        <p class="text-muted mb-2"><i class="bi bi-geo-alt"></i> <c:out value="${item.direccionEmpresa}"/></p>
                        <p class="mb-0">
                                <span class="status" data-state="${item.estadoReporte}">
                                    Reporte <c:out value="${item.estadoReporte}"/>
                                </span>
                        </p>
                    </article>
                </c:forEach>
            </section>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>