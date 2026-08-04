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
    <title>Revisar documentos - Estadías</title>
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
            <h1 class="page-title">Documentos de <c:out value="${expediente.docente}"/></h1>
            <p class="page-subtitle"><c:out value="${expediente.division}"/> - <c:out value="${expediente.carrera}"/></p>
        </div>
        <a class="btn-navy" href="${ctx}/estadias/documentos"><i class="bi bi-arrow-left"></i>Volver</a>
    </header>

    <section class="panel">
        <h2 class="section-title">Archivos permitidos</h2>
        <p class="page-subtitle mb-3">Sólo se muestran Solicitud de visita, Carta responsiva y Reporte.</p>

        <div class="document-grid">
            <c:forEach var="doc" items="${expediente.documentos}">
                <article class="document-card">
                    <h3><c:out value="${doc.tipoLegible}"/></h3>
                    <p class="text-muted"><c:out value="${doc.nombreArchivo}"/></p>
                    <span class="status" data-state="${doc.estado}"><c:out value="${doc.estado}"/></span>

                    <c:if test="${not empty doc.observaciones}">
                        <p class="small text-danger mt-2"><c:out value="${doc.observaciones}"/></p>
                    </c:if>

                    <div class="document-actions">
                        <a class="btn-navy" target="_blank" href="${ctx}/archivo?id=${doc.idDocumento}"><i class="bi bi-eye"></i>Ver</a>
                        <a class="btn-navy" href="${ctx}/archivo?id=${doc.idDocumento}&descargar=1"><i class="bi bi-download"></i>Descargar</a>
                    </div>

                    <c:choose>
                        <c:when test="${doc.tipoDocumento == 'REPORTE'}">
                            <a class="btn-orange w-100 mt-3" href="${ctx}/estadias/reporte?id=${expediente.idVisita}">
                                <i class="bi bi-journal-check"></i>Revisar reporte completo
                            </a>
                        </c:when>
                        <c:otherwise>
                            <form class="mt-3" method="post" action="${ctx}/estadias/documento">
                                <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                                <input type="hidden" name="documentoId" value="${doc.idDocumento}">
                                <textarea class="form-control mb-2" name="observaciones" maxlength="500" rows="2" placeholder="Observaciones obligatorias al rechazar"></textarea>
                                <div class="d-flex gap-2">
                                    <button class="btn-success-soft flex-fill" name="decision" value="ACEPTAR">Aceptar</button>
                                    <button class="btn-danger-soft flex-fill" name="decision" value="RECHAZAR">Rechazar</button>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </article>
            </c:forEach>

            <c:if test="${empty expediente.documentos}">
                <div class="empty"><i class="bi bi-folder2-open"></i>No hay documentos para esta solicitud.</div>
            </c:if>
        </div>
    </section>
</main>
</body>
</html>