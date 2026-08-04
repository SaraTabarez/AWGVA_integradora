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
    <title>Detalle de solicitud - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="portal-main">
    <header class="page-top">
        <div>
            <div class="eyebrow">Solicitud #<c:out value="${expediente.idVisita}"/></div>
            <h1 class="page-title"><c:out value="${expediente.titulo}"/></h1>
            <p class="page-subtitle">
                    <span class="status" data-state="${expediente.estado}">
                        <c:out value="${expediente.estadoLegible}"/>
                    </span>
            </p>
        </div>
        <a class="btn-navy" href="${ctx}/mis-solicitudes"><i class="bi bi-arrow-left"></i>Volver</a>
    </header>

    <c:if test="${param.subido == '1'}">
        <div class="alert-success-soft">Documento enviado a Estadías correctamente.</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert-error-soft"><c:out value="${error}"/></div>
    </c:if>

    <section class="detail-grid">
        <div class="detail-card">
            <h2>Datos principales</h2>
            <div class="data-row">
                <span>Empresa</span>
                <strong><c:out value="${expediente.empresa}"/></strong>
            </div>
            <div class="data-row">
                <span>Dirección</span>
                <strong><c:out value="${expediente.direccionEmpresa}"/></strong>
            </div>
            <div class="data-row">
                <span>Periodo</span>
                <strong><c:out value="${expediente.fechaInicio}"/> al <c:out value="${expediente.fechaFin}"/></strong>
            </div>
            <div class="data-row">
                <span>Propósito</span>
                <strong><c:out value="${expediente.proposito}"/></strong>
            </div>
        </div>

        <div class="detail-card">
            <h2>Participantes</h2>
            <div class="data-row">
                <span>División</span>
                <strong><c:out value="${expediente.division}"/></strong>
            </div>
            <div class="data-row">
                <span>Carrera</span>
                <strong><c:out value="${expediente.carrera}"/></strong>
            </div>
            <div class="data-row">
                <span>Grupo</span>
                <strong><c:out value="${expediente.semestre}"/> - <c:out value="${expediente.grupo}"/></strong>
            </div>
            <div class="data-row">
                <span>Estudiantes</span>
                <strong><c:out value="${expediente.numeroEstudiantes}"/></strong>
            </div>
        </div>
    </section>

    <section class="panel mt-4">
        <h2 class="section-title">Documentos de esta solicitud</h2>
        <p class="page-subtitle mb-3">Sólo tú puedes consultar y reemplazar estos archivos. Estadías recibe el mismo registro para aprobarlo o rechazarlo.</p>

        <div class="document-grid">
            <c:forEach var="tipo" items="${['SOLICITUD_VISITA','CARTA_RESPONSIVA','REPORTE']}">
                <c:set var="actual" value="${null}"/>
                <c:forEach var="doc" items="${expediente.documentos}">
                    <c:if test="${doc.tipoDocumento == tipo}">
                        <c:set var="actual" value="${doc}"/>
                    </c:if>
                </c:forEach>

                <article class="document-card">
                    <h3>
                        <c:choose>
                            <c:when test="${tipo == 'SOLICITUD_VISITA'}">Solicitud de visita</c:when>
                            <c:when test="${tipo == 'CARTA_RESPONSIVA'}">Carta responsiva</c:when>
                            <c:otherwise>Reporte</c:otherwise>
                        </c:choose>
                    </h3>

                    <c:choose>
                        <c:when test="${not empty actual}">
                            <p><c:out value="${actual.nombreArchivo}"/></p>
                            <span class="status" data-state="${actual.estado}"><c:out value="${actual.estado}"/></span>
                            <c:if test="${not empty actual.observaciones}">
                                <p class="text-danger small mt-2"><c:out value="${actual.observaciones}"/></p>
                            </c:if>
                            <div class="document-actions">
                                <a class="btn-navy" target="_blank" href="${ctx}/archivo?id=${actual.idDocumento}">
                                    <i class="bi bi-eye"></i>Ver
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">Aún no se ha enviado.</p>
                        </c:otherwise>
                    </c:choose>

                    <form class="mt-3" method="post" action="${ctx}/documentos" enctype="multipart/form-data">
                        <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                        <input type="hidden" name="visitaId" value="${expediente.idVisita}">
                        <input type="hidden" name="tipoDocumento" value="${tipo}">
                        <input class="form-control mb-2" type="file" name="archivo" accept=".pdf,.png,.jpg,.jpeg,.webp" required>
                        <button class="btn-orange w-100" type="submit">
                            <i class="bi bi-cloud-arrow-up"></i>${empty actual ? 'Subir' : 'Reemplazar'}
                        </button>
                    </form>
                </article>
            </c:forEach>
        </div>
    </section>
</main>
</body>
</html>
