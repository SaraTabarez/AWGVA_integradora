<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 04/08/2026
  Time: 08:32 a. m.
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
  <title>Detalle de solicitud - Dirección</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
  <link href="${ctx}/assets/css/portal.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="portal-main">
  <header class="page-top">
    <div>
      <div class="eyebrow">Vista de detalles</div>
      <h1 class="page-title">Solicitud de Visita Industrial - <c:out value="${expediente.division}"/></h1>
      <p class="page-subtitle">
                    <span class="status" data-state="${expediente.estado}">
                        <c:out value="${expediente.estadoLegible}"/>
                    </span>
      </p>
    </div>
    <a class="btn-navy" href="${ctx}/director/${param.origen == 'historico' ? 'historico' : 'solicitudes'}">
      <i class="bi bi-arrow-left"></i>Atrás
    </a>
  </header>

  <section class="detail-grid">
    <article class="detail-card">
      <h2><i class="bi bi-geo-alt"></i> Detalles principales</h2>
      <div class="data-row">
        <span>Lugar de visita</span>
        <strong><c:out value="${expediente.empresa}"/></strong>
      </div>
      <div class="data-row">
        <span>Fecha de visita</span>
        <strong><c:out value="${expediente.fechaInicio}"/> - <c:out value="${expediente.fechaFin}"/></strong>
      </div>
      <div class="data-row">
        <span>Carrera y grupo</span>
        <strong><c:out value="${expediente.carrera}"/> / <c:out value="${expediente.grupo}"/></strong>
      </div>
    </article>

    <article class="detail-card">
      <h2><i class="bi bi-building"></i> Información de la empresa</h2>
      <div class="data-row">
        <span>Nombre</span>
        <strong><c:out value="${expediente.empresa}"/></strong>
      </div>
      <div class="data-row">
        <span>Teléfono</span>
        <strong><c:out value="${expediente.telefonoEmpresa}"/></strong>
      </div>
      <div class="data-row">
        <span>Correo electrónico</span>
        <strong><c:out value="${expediente.correoEmpresa}"/></strong>
      </div>
      <div class="data-row">
        <span>Dirección</span>
        <strong><c:out value="${expediente.direccionEmpresa}"/></strong>
      </div>
    </article>
  </section>

  <section class="panel mt-4">
    <h2 class="section-title"><i class="bi bi-people"></i> Participantes</h2>
    <div class="detail-grid">
      <div>
        <div class="data-row">
          <span>Área solicitante</span>
          <strong><c:out value="${expediente.division}"/></strong>
        </div>
        <div class="data-row">
          <span>Docente responsable</span>
          <strong><c:out value="${expediente.docente}"/></strong>
        </div>
      </div>
      <div>
        <div class="data-row">
          <span>Docente acompañante</span>
          <strong><c:out value="${expediente.docenteAcompanante}"/></strong>
        </div>
        <div class="data-row">
          <span>Estudiantes</span>
          <strong><c:out value="${expediente.numeroEstudiantes}"/></strong>
        </div>
      </div>
    </div>
  </section>

  <c:if test="${expediente.estado == 'PENDIENTE_DIRECTOR' && param.origen != 'historico'}">
    <section class="panel">
      <h2 class="section-title">Resolución de Dirección</h2>
      <form method="post" action="${ctx}/director/solicitud">
        <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
        <input type="hidden" name="id" value="${expediente.idVisita}">

        <label class="form-label">Motivo u observaciones (obligatorio al rechazar)</label>
        <textarea class="form-control mb-3" name="motivo" rows="3" maxlength="500"></textarea>

        <div class="d-flex gap-2">
          <button class="btn-success-soft" name="decision" value="ACEPTAR" type="submit">
            <i class="bi bi-check-circle"></i>Aceptar solicitud
          </button>
          <button class="btn-danger-soft" name="decision" value="RECHAZAR" type="submit">
            <i class="bi bi-x-circle"></i>Rechazar solicitud
          </button>
        </div>
      </form>
    </section>
  </c:if>

  <c:if test="${not empty expediente.motivoRechazo}">
    <div class="alert-error-soft">
      <strong>Observaciones:</strong> <c:out value="${expediente.motivoRechazo}"/>
    </div>
  </c:if>
</main>
</body>
</html>
