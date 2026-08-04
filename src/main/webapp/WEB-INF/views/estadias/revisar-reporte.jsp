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
    <title>Reporte de visita - Estadías</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="portal-main">
    <header class="page-top">
        <div>
            <div class="eyebrow">Detalles de reporte docente</div>
            <h1 class="page-title">Reporte de visita académica</h1>
            <p class="page-subtitle">Solicitud #<c:out value="${expediente.idVisita}"/> - <c:out value="${expediente.empresa}"/></p>
        </div>
        <a class="btn-navy" href="${ctx}/estadias/documento?id=${expediente.idVisita}"><i class="bi bi-arrow-left"></i>Atrás</a>
    </header>

    <section class="detail-grid">
        <article class="detail-card">
            <h2>Datos de participantes</h2>
            <div class="data-row"><span>Área solicitante</span><strong><c:out value="${expediente.division}"/></strong></div>
            <div class="data-row"><span>Docente responsable</span><strong><c:out value="${expediente.docente}"/></strong></div>
            <div class="data-row"><span>Programa educativo</span><strong><c:out value="${expediente.carrera}"/></strong></div>
            <div class="data-row"><span>Grupo y estudiantes</span><strong><c:out value="${expediente.grupo}"/> - <c:out value="${expediente.numeroEstudiantes}"/> estudiantes</strong></div>
        </article>

        <article class="detail-card">
            <h2>Datos del lugar</h2>
            <div class="data-row"><span>Empresa</span><strong><c:out value="${expediente.empresa}"/></strong></div>
            <div class="data-row"><span>Dirección</span><strong><c:out value="${expediente.direccionEmpresa}"/></strong></div>
            <div class="data-row"><span>Contacto</span><strong><c:out value="${expediente.telefonoEmpresa}"/> / <c:out value="${expediente.correoEmpresa}"/></strong></div>
            <div class="data-row"><span>Periodo</span><strong><c:out value="${expediente.fechaInicio}"/> - <c:out value="${expediente.fechaFin}"/></strong></div>
        </article>
    </section>

    <section class="panel mt-4">
        <h2 class="section-title">Archivo del reporte</h2>
        <iframe class="preview" title="Vista previa del reporte" src="${ctx}/archivo?id=${reporte.idDocumento}"></iframe>
        <div class="document-actions">
            <a class="btn-navy" href="${ctx}/archivo?id=${reporte.idDocumento}&descargar=1"><i class="bi bi-download"></i>Descargar reporte</a>
        </div>
    </section>

    <section class="panel">
        <h2 class="section-title">Resolución de Estadías</h2>
        <form method="post" action="${ctx}/estadias/reporte">
            <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
            <input type="hidden" name="documentoId" value="${reporte.idDocumento}">

            <label class="form-label">Observaciones (obligatorias al rechazar)</label>
            <textarea class="form-control mb-3" name="observaciones" rows="3" maxlength="500"></textarea>

            <div class="d-flex gap-2">
                <button class="btn-danger-soft" name="decision" value="RECHAZAR"><i class="bi bi-x-circle"></i>Rechazar reporte</button>
                <button class="btn-success-soft" name="decision" value="ACEPTAR"><i class="bi bi-check-circle"></i>Aprobar reporte</button>
            </div>
        </form>
    </section>
</main>
</body>
</html>