<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="division" value="${sessionScope.usuario.nombreDivision}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Solicitud de visitas académicas - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css?v=20260804-figma2" rel="stylesheet">
</head>
<body class="docente-figma">
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="solicitud-document">
    <form id="solicitudForm" method="post" action="${ctx}/nueva-solicitud"
          data-open-step-two="${not empty error ? 'true' : 'false'}">
        <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>"/>
        <input type="hidden" id="titulo" name="titulo" value="<c:out value='${param.titulo}'/>"/>

        <c:if test="${not empty error}">
            <div class="solicitud-error"><i class="bi bi-exclamation-circle"></i> <c:out value="${error}"/></div>
        </c:if>

        <section id="solicitudPaso1" class="solicitud-step" data-step="1">
            <div class="solicitud-heading">
                <h1>SOLICITUD DE VISITAS ACADÉMICAS</h1>
                <img src="https://upload.wikimedia.org/wikipedia/commons/b/b3/Logo-utez.png"
                     alt="Universidad Tecnológica Emiliano Zapata"
                     onerror="this.style.display='none'">
            </div>

            <h2 class="solicitud-section-title"><i class="bi bi-person"></i> Datos del Solicitante</h2>
            <div class="solicitud-grid">
                <div class="solicitud-field">
                    <label class="solicitud-label" for="nombreSolicitante">Nombre Completo *</label>
                    <input id="nombreSolicitante" class="solicitud-input" type="text"
                           value="<c:out value='${sessionScope.usuario.nombreCompleto}'/>" readonly>
                </div>
                <div class="solicitud-field">
                    <label class="solicitud-label" for="cargoSolicitante">Cargo / Rol *</label>
                    <input id="cargoSolicitante" class="solicitud-input" type="text" value="DOCENTE" readonly>
                </div>
                <div class="solicitud-field">
                    <label class="solicitud-label" for="telefonoDocente">Teléfono de contacto *</label>
                    <input id="telefonoDocente" name="telefonoDocente" class="solicitud-input" type="tel"
                           maxlength="20" placeholder="Teléfono del solicitante" required
                           value="<c:out value='${param.telefonoDocente}'/>">
                </div>
                <div class="solicitud-field">
                    <label class="solicitud-label" for="docenteAcompanante">No. de Docentes acompañantes</label>
                    <input id="docenteAcompanante" name="docenteAcompanante" class="solicitud-input" type="number"
                           min="0" max="3" placeholder="Máximo 3 acompañantes"
                           value="<c:out value='${param.docenteAcompanante}'/>">
                </div>
            </div>

            <h2 class="solicitud-section-title"><i class="bi bi-map"></i> Datos de la visita</h2>
            <div class="solicitud-grid">
                <div class="solicitud-field">
                    <label class="solicitud-label" for="direccionEmpresa">Dirección del lugar de la visita *</label>
                    <input id="direccionEmpresa" name="direccionEmpresa" class="solicitud-input" maxlength="300"
                           placeholder="Ubicación del lugar de la visita" required
                           value="<c:out value='${param.direccionEmpresa}'/>">
                </div>
                <div class="solicitud-field">
                    <label class="solicitud-label" for="empresa">Nombre de la empresa a visitar *</label>
                    <input id="empresa" name="empresa" class="solicitud-input" maxlength="180"
                           placeholder="Nombre del lugar a visitar" required
                           value="<c:out value='${param.empresa}'/>">
                </div>
                <div class="solicitud-field">
                    <label class="solicitud-label" for="telefonoEmpresa">Teléfono de contacto *</label>
                    <input id="telefonoEmpresa" name="telefonoEmpresa" class="solicitud-input" type="tel"
                           maxlength="30" placeholder="Teléfono del lugar a visitar" required
                           value="<c:out value='${param.telefonoEmpresa}'/>">
                </div>
                <div class="solicitud-field">
                    <label class="solicitud-label" for="correoEmpresa">Correo electrónico del lugar de la visita *</label>
                    <input id="correoEmpresa" name="correoEmpresa" class="solicitud-input" type="email"
                           maxlength="160" placeholder="empresa@com.mx" required
                           value="<c:out value='${param.correoEmpresa}'/>">
                </div>
            </div>

            <div class="solicitud-grid three" style="margin-top:11px">
                <div class="solicitud-field">
                    <label class="solicitud-label" for="fechaInicio">Fecha de inicio *</label>
                    <input id="fechaInicio" name="fechaInicio" class="solicitud-input" type="date" required
                           value="<c:out value='${param.fechaInicio}'/>">
                </div>
                <div class="solicitud-field">
                    <label class="solicitud-label" for="fechaFin">Fecha de término *</label>
                    <input id="fechaFin" name="fechaFin" class="solicitud-input" type="date" required
                           value="<c:out value='${param.fechaFin}'/>">
                </div>
                <div class="solicitud-field">
                    <label class="solicitud-label" for="horaInicio">Hora inicio *</label>
                    <input id="horaInicio" name="horaInicio" class="solicitud-input" type="time" required
                           value="<c:out value='${param.horaInicio}'/>">
                </div>
            </div>

            <div class="solicitud-field full" style="margin-top:11px">
                <label class="solicitud-label" for="proposito">Objetivo de la visita *</label>
                <textarea id="proposito" name="proposito" class="solicitud-textarea" maxlength="1000"
                          placeholder="Describir detalladamente el objetivo para la visita" required><c:out value="${param.proposito}"/></textarea>
            </div>

            <div class="solicitud-field full" style="margin-top:11px">
                <div class="solicitud-label">No. de estudiantes participantes por división académica: *</div>
                <div class="division-count-grid">
                    <div class="division-count-cell"><span>DACEA</span>
                        <c:choose><c:when test="${division == 'DACEA'}"><input class="division-students" type="number" min="1" max="200" value="${empty param.numeroEstudiantes ? 1 : param.numeroEstudiantes}"></c:when><c:otherwise><input type="number" value="0" disabled></c:otherwise></c:choose>
                    </div>
                    <div class="division-count-cell"><span>DATEFI</span>
                        <c:choose><c:when test="${division == 'DATEFI'}"><input class="division-students" type="number" min="1" max="200" value="${empty param.numeroEstudiantes ? 1 : param.numeroEstudiantes}"></c:when><c:otherwise><input type="number" value="0" disabled></c:otherwise></c:choose>
                    </div>
                    <div class="division-count-cell"><span>DATID</span>
                        <c:choose><c:when test="${division == 'DATID'}"><input class="division-students" type="number" min="1" max="200" value="${empty param.numeroEstudiantes ? 1 : param.numeroEstudiantes}"></c:when><c:otherwise><input type="number" value="0" disabled></c:otherwise></c:choose>
                    </div>
                    <div class="division-count-cell"><span>DAMI</span>
                        <c:choose><c:when test="${division == 'DAMI'}"><input class="division-students" type="number" min="1" max="200" value="${empty param.numeroEstudiantes ? 1 : param.numeroEstudiantes}"></c:when><c:otherwise><input type="number" value="0" disabled></c:otherwise></c:choose>
                    </div>
                    <div class="division-count-cell"><span>Total estudiantes</span><input id="totalEstudiantes" type="number" readonly value="${empty param.numeroEstudiantes ? 1 : param.numeroEstudiantes}"></div>
                </div>
            </div>

            <div class="solicitud-actions">
                <a class="figma-orange-button" href="${ctx}/inicio">Atrás</a>
                <button class="figma-orange-button" type="button" id="btnSiguiente">Siguiente</button>
            </div>
        </section>

        <section id="solicitudPaso2" class="solicitud-step" data-step="2" hidden>
            <div class="solicitud-heading">
                <h1>SOLICITUD DE VISITAS ACADÉMICAS</h1>
                <img src="https://upload.wikimedia.org/wikipedia/commons/b/b3/Logo-utez.png"
                     alt="Universidad Tecnológica Emiliano Zapata"
                     onerror="this.style.display='none'">
            </div>

            <p class="solicitud-intro">La siguiente información es de llenado exclusivo para visita académica.</p>

            <div class="academic-row">
                <div class="academic-cell">
                    <label for="carrera">Programa Educativo</label>
                    <select id="carrera" name="carrera" required>
                        <option value="">Selecciona tu programa</option>
                        <c:forEach var="carrera" items="${carreras}">
                            <option value="<c:out value='${carrera}'/>" ${param.carrera == carrera ? 'selected' : ''}><c:out value="${carrera}"/></option>
                        </c:forEach>
                    </select>
                </div>
                <div class="academic-cell">
                    <label for="semestre">Cuatrimestre</label>
                    <input id="semestre" name="semestre" maxlength="30" required value="<c:out value='${param.semestre}'/>">
                </div>
                <div class="academic-cell">
                    <label for="grupo">Grupo</label>
                    <input id="grupo" name="grupo" maxlength="50" required value="<c:out value='${param.grupo}'/>">
                </div>
                <div class="academic-cell">
                    <label for="numeroEstudiantes">No. Estudiantes</label>
                    <input id="numeroEstudiantes" name="numeroEstudiantes" type="number" min="1" max="200" required
                           value="${empty param.numeroEstudiantes ? 1 : param.numeroEstudiantes}">
                </div>
            </div>

            <div class="solicitud-field full" style="margin-top:20px">
                <label class="solicitud-label" for="asignatura">Asignaturas que se reforzarán con la visita *</label>
                <textarea id="asignatura" name="asignatura" class="solicitud-textarea" rows="4" maxlength="500" required><c:out value="${param.asignatura}"/></textarea>
            </div>

            <div class="solicitud-actions" style="margin-top:34vh">
                <button class="figma-orange-button" type="button" id="btnAtrasPaso">Atrás</button>
                <button class="figma-orange-button" type="submit">Enviar Solicitud</button>
            </div>
        </section>
    </form>
</main>

<script>
    (() => {
        const form = document.getElementById('solicitudForm');
        const paso1 = document.getElementById('solicitudPaso1');
        const paso2 = document.getElementById('solicitudPaso2');
        const empresa = document.getElementById('empresa');
        const titulo = document.getElementById('titulo');
        const divisionStudents = document.querySelector('.division-students');
        const total = document.getElementById('totalEstudiantes');
        const numeroEstudiantes = document.getElementById('numeroEstudiantes');

        function actualizarTitulo() {
            titulo.value = empresa.value.trim()
                ? 'Visita académica a ' + empresa.value.trim()
                : 'Visita académica';
        }

        function sincronizarEstudiantes(source) {
            const value = Math.max(1, Math.min(200, Number.parseInt(source.value, 10) || 1));
            if (divisionStudents) divisionStudents.value = value;
            total.value = value;
            numeroEstudiantes.value = value;
        }

        function mostrarPaso(numero) {
            const segundo = numero === 2;
            paso1.hidden = segundo;
            paso2.hidden = !segundo;
            window.scrollTo({top: 0, behavior: 'smooth'});
        }

        function validarPasoUno() {
            const required = paso1.querySelectorAll('[required]');
            for (const field of required) {
                if (!field.checkValidity()) {
                    field.reportValidity();
                    field.focus();
                    return false;
                }
            }
            return true;
        }

        empresa.addEventListener('input', actualizarTitulo);
        if (divisionStudents) {
            divisionStudents.addEventListener('input', () => sincronizarEstudiantes(divisionStudents));
        }
        numeroEstudiantes.addEventListener('input', () => sincronizarEstudiantes(numeroEstudiantes));

        const fechaInicio = document.getElementById('fechaInicio');
        const fechaFin = document.getElementById('fechaFin');
        fechaInicio.addEventListener('change', () => {
            fechaFin.min = fechaInicio.value;
            if (fechaFin.value && fechaFin.value < fechaInicio.value) fechaFin.value = fechaInicio.value;
        });

        document.getElementById('btnSiguiente').addEventListener('click', () => {
            if (!validarPasoUno()) return;
            actualizarTitulo();
            sincronizarEstudiantes(divisionStudents || numeroEstudiantes);
            mostrarPaso(2);
        });

        document.getElementById('btnAtrasPaso').addEventListener('click', () => mostrarPaso(1));
        form.addEventListener('submit', actualizarTitulo);

        actualizarTitulo();
        sincronizarEstudiantes(numeroEstudiantes);
        if (fechaInicio.value) fechaFin.min = fechaInicio.value;
        if (form.dataset.openStepTwo === 'true') mostrarPaso(2);
    })();
</script>
</body>
</html>