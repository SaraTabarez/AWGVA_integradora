<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Detalle de solicitud - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css?v=20260804-figma2" rel="stylesheet">
</head>
<body class="docente-figma">
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="docente-main">
    <header class="docente-topbar">
        <div>
            <h1 class="docente-page-title">Detalle de solicitud</h1>
            <p class="docente-page-subtitle">Solicitud #<c:out value="${expediente.idVisita}"/></p>
        </div>
        <a class="figma-outline-button" href="${ctx}/mis-solicitudes">
            <i class="bi bi-arrow-left"></i> Volver
        </a>
    </header>

    <c:if test="${param.subido == '1'}">
        <div class="docente-alert"><i class="bi bi-check-circle"></i> Documento enviado a Estadías correctamente.</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="solicitud-error"><i class="bi bi-exclamation-circle"></i> <c:out value="${error}"/></div>
    </c:if>

    <section class="figma-request-heading">
        <div>
            <span>Solicitud de visita académica</span>
            <h2><c:out value="${expediente.titulo}"/></h2>
        </div>
        <span class="figma-request-status" data-state="${expediente.estado}">
            <c:out value="${expediente.estadoLegible}"/>
        </span>
    </section>

    <section class="figma-detail-grid" aria-label="Datos de la solicitud">
        <article class="figma-detail-card">
            <h2><i class="bi bi-building"></i> Datos de la visita</h2>
            <div class="figma-data-row"><span>Empresa</span><strong><c:out value="${expediente.empresa}"/></strong></div>
            <div class="figma-data-row"><span>Dirección</span><strong><c:out value="${expediente.direccionEmpresa}"/></strong></div>
            <div class="figma-data-row"><span>Periodo</span><strong><c:out value="${expediente.fechaInicio}"/> al <c:out value="${expediente.fechaFin}"/></strong></div>
            <div class="figma-data-row"><span>Propósito</span><strong><c:out value="${expediente.proposito}"/></strong></div>
        </article>

        <article class="figma-detail-card">
            <h2><i class="bi bi-people"></i> Datos académicos</h2>
            <div class="figma-data-row"><span>División</span><strong><c:out value="${expediente.division}"/></strong></div>
            <div class="figma-data-row"><span>Carrera</span><strong><c:out value="${expediente.carrera}"/></strong></div>
            <div class="figma-data-row"><span>Cuatrimestre y grupo</span><strong><c:out value="${expediente.semestre}"/> - <c:out value="${expediente.grupo}"/></strong></div>
            <div class="figma-data-row"><span>Estudiantes</span><strong><c:out value="${expediente.numeroEstudiantes}"/></strong></div>
            <div class="figma-data-row"><span>Asignatura</span><strong><c:out value="${expediente.asignatura}"/></strong></div>
        </article>
    </section>

    <section class="figma-document-section" aria-label="Documentos de esta solicitud">
        <h2>Documentos de esta solicitud</h2>
        <p>Los archivos que subas aquí son los mismos que revisará Estadías.</p>

        <div class="figma-documents">
            <c:forEach var="tipo" items="${['SOLICITUD_VISITA','CARTA_RESPONSIVA','REPORTE']}">
                <c:set var="actual" value="${null}"/>
                <c:forEach var="doc" items="${expediente.documentos}">
                    <c:if test="${doc.tipoDocumento == tipo}"><c:set var="actual" value="${doc}"/></c:if>
                </c:forEach>

                <article class="figma-document-card">
                    <h3>
                        <c:choose>
                            <c:when test="${tipo == 'SOLICITUD_VISITA'}">Solicitud de visita</c:when>
                            <c:when test="${tipo == 'CARTA_RESPONSIVA'}">Carta responsiva</c:when>
                            <c:otherwise>Reporte</c:otherwise>
                        </c:choose>
                    </h3>

                    <c:choose>
                        <c:when test="${not empty actual}">
                            <p class="figma-file-name"><i class="bi bi-file-earmark-pdf"></i> <c:out value="${actual.nombreArchivo}"/></p>
                            <span class="figma-request-status" data-state="${actual.estado}"><c:out value="${actual.estado}"/></span>
                            <c:if test="${not empty actual.observaciones}">
                                <p class="figma-document-observation"><c:out value="${actual.observaciones}"/></p>
                            </c:if>
                            <a class="figma-file-link" target="_blank" rel="noopener" href="${ctx}/archivo?id=${actual.idDocumento}">
                                <i class="bi bi-eye"></i> Ver archivo
                            </a>
                        </c:when>
                        <c:otherwise>
                            <p class="figma-file-empty">Aún no se ha enviado.</p>
                        </c:otherwise>
                    </c:choose>

                    <form class="figma-upload-form" method="post" action="${ctx}/documentos" enctype="multipart/form-data">
                        <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                        <input type="hidden" name="visitaId" value="<c:out value='${expediente.idVisita}'/>">
                        <input type="hidden" name="tipoDocumento" value="<c:out value='${tipo}'/>">
                        <input type="file" name="archivo" accept=".pdf,.png,.jpg,.jpeg,.webp" required>
                        <button class="figma-orange-button" type="submit">
                            <i class="bi bi-cloud-arrow-up"></i> ${empty actual ? 'Subir' : 'Reemplazar'}
                        </button>
                    </form>
                </article>
            </c:forEach>
        </div>
    </section>
</main>
</body>
</html>