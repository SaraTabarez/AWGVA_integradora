<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 04/08/2026
  Time: 08:36 a. m.
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
    <title>Nueva solicitud - AWGVA</title>
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
            <h1 class="page-title">Solicitud de visita académica</h1>
            <p class="page-subtitle">División asignada: <strong><c:out value="${sessionScope.usuario.nombreDivision}"/></strong></p>
        </div>
    </header>

    <c:if test="${not empty error}">
        <div class="alert-error-soft"><c:out value="${error}"/></div>
    </c:if>

    <form class="panel" method="post" action="${ctx}/nueva-solicitud">
        <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>"/>

        <h2 class="section-title"><i class="bi bi-journal-text"></i> Datos académicos</h2>
        <div class="form-grid">
            <div class="full">
                <label class="form-label">Título de la visita *</label>
                <input class="form-control" name="titulo" maxlength="180" required value="<c:out value='${param.titulo}'/>">
            </div>
            <div>
                <label class="form-label">Carrera de tu división *</label>
                <select class="form-select" name="carrera" required>
                    <option value="">Selecciona</option>
                    <c:forEach var="carrera" items="${carreras}">
                        <option value="<c:out value='${carrera}'/>" ${param.carrera == carrera ? 'selected' : ''}>
                            <c:out value="${carrera}"/>
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label class="form-label">Asignatura a reforzar *</label>
                <input class="form-control" name="asignatura" maxlength="500" required value="<c:out value='${param.asignatura}'/>">
            </div>
            <div>
                <label class="form-label">Semestre o cuatrimestre *</label>
                <input class="form-control" name="semestre" maxlength="30" required value="<c:out value='${param.semestre}'/>">
            </div>
            <div>
                <label class="form-label">Grupo *</label>
                <input class="form-control" name="grupo" maxlength="50" required value="<c:out value='${param.grupo}'/>">
            </div>
            <div>
                <label class="form-label">Número de estudiantes *</label>
                <input class="form-control" type="number" name="numeroEstudiantes" min="1" max="200" required value="<c:out value='${param.numeroEstudiantes}'/>">
            </div>
            <div>
                <label class="form-label">Docente acompañante</label>
                <input class="form-control" name="docenteAcompanante" maxlength="180" value="<c:out value='${param.docenteAcompanante}'/>">
            </div>
        </div>

        <h2 class="section-title mt-4"><i class="bi bi-building"></i> Empresa y visita</h2>
        <div class="form-grid">
            <div>
                <label class="form-label">Empresa o institución *</label>
                <input class="form-control" name="empresa" maxlength="180" required value="<c:out value='${param.empresa}'/>">
            </div>
            <div>
                <label class="form-label">Dirección *</label>
                <input class="form-control" name="direccionEmpresa" maxlength="300" required value="<c:out value='${param.direccionEmpresa}'/>">
            </div>
            <div>
                <label class="form-label">Teléfono</label>
                <input class="form-control" name="telefonoEmpresa" maxlength="30" value="<c:out value='${param.telefonoEmpresa}'/>">
            </div>
            <div>
                <label class="form-label">Correo</label>
                <input class="form-control" type="email" name="correoEmpresa" maxlength="160" value="<c:out value='${param.correoEmpresa}'/>">
            </div>
            <div>
                <label class="form-label">Fecha de inicio *</label>
                <input class="form-control" type="date" name="fechaInicio" required value="<c:out value='${param.fechaInicio}'/>">
            </div>
            <div>
                <label class="form-label">Fecha de término *</label>
                <input class="form-control" type="date" name="fechaFin" required value="<c:out value='${param.fechaFin}'/>">
            </div>
            <div class="full">
                <label class="form-label">Propósito de la visita *</label>
                <textarea class="form-control" name="proposito" rows="4" maxlength="1000" required><c:out value="${param.proposito}"/></textarea>
            </div>
        </div>

        <div class="d-flex justify-content-between mt-4">
            <a class="btn-navy" href="${ctx}/inicio"><i class="bi bi-arrow-left"></i>Atrás al inicio</a>
            <button class="btn-orange" type="submit">Enviar solicitud<i class="bi bi-arrow-right"></i></button>
        </div>
    </form>
</main>
</body>
</html>