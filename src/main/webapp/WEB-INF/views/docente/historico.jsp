<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Histórico docente - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css?v=20260804-figma2" rel="stylesheet">
</head>
<body class="docente-figma">
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="docente-main">
    <header class="docente-topbar">
        <div>
            <h1 class="docente-page-title">Histórico</h1>
            <p class="docente-page-subtitle">Solicitudes completadas con reporte aceptado.</p>
        </div>
    </header>

    <div class="figma-filter-bar" aria-label="Filtros del histórico">
        <label class="figma-filter figma-filter-search">
            <span>Buscar</span>
            <span class="figma-filter-control">
                <i class="bi bi-search" aria-hidden="true"></i>
                <input id="historicoBuscar" type="search" placeholder="Empresa, carrera o grupo">
            </span>
        </label>
        <label class="figma-filter">
            <span>Desde</span>
            <input id="historicoDesde" type="date">
        </label>
        <label class="figma-filter">
            <span>Hasta</span>
            <input id="historicoHasta" type="date">
        </label>
        <button id="limpiarFiltros" class="figma-outline-button" type="button">Limpiar</button>
    </div>

    <c:choose>
        <c:when test="${empty solicitudes}">
            <div class="docente-empty">
                <i class="bi bi-clock-history me-2"></i>No hay solicitudes completadas con reporte aceptado.
            </div>
        </c:when>
        <c:otherwise>
            <section class="figma-table-wrap" aria-label="Histórico de solicitudes completadas">
                <table class="figma-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Empresa</th>
                        <th>Fecha</th>
                        <th>Carrera</th>
                        <th>Grupo</th>
                        <th>Detalle</th>
                    </tr>
                    </thead>
                    <tbody id="historicoFilas">
                    <c:forEach var="item" items="${solicitudes}">
                        <tr data-fecha="<c:out value='${item.fechaInicio}'/>">
                            <td>#<c:out value="${item.idVisita}"/></td>
                            <td><c:out value="${item.empresa}"/></td>
                            <td><c:out value="${item.fechaInicio}"/></td>
                            <td><c:out value="${item.carrera}"/></td>
                            <td><c:out value="${item.grupo}"/></td>
                            <td>
                                <a class="figma-eye-button" href="${ctx}/detalle-solicitud?id=${item.idVisita}"
                                   aria-label="Ver solicitud ${item.idVisita}" title="Ver detalle">
                                    <i class="bi bi-eye"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <p id="historicoSinResultados" class="docente-table-empty" hidden>No hay resultados con esos filtros.</p>
            </section>
        </c:otherwise>
    </c:choose>
</main>

<script>
    (() => {
        const tbody = document.getElementById('historicoFilas');
        if (!tbody) return;

        const buscar = document.getElementById('historicoBuscar');
        const desde = document.getElementById('historicoDesde');
        const hasta = document.getElementById('historicoHasta');
        const sinResultados = document.getElementById('historicoSinResultados');
        const filas = Array.from(tbody.querySelectorAll('tr'));

        function filtrar() {
            const texto = buscar.value.trim().toLocaleLowerCase('es');
            let visibles = 0;

            filas.forEach((fila) => {
                const fecha = fila.dataset.fecha || '';
                const coincideTexto = !texto || fila.textContent.toLocaleLowerCase('es').includes(texto);
                const coincideDesde = !desde.value || fecha >= desde.value;
                const coincideHasta = !hasta.value || fecha <= hasta.value;
                const visible = coincideTexto && coincideDesde && coincideHasta;
                fila.hidden = !visible;
                if (visible) visibles += 1;
            });

            sinResultados.hidden = visibles !== 0;
        }

        [buscar, desde, hasta].forEach((control) => control.addEventListener('input', filtrar));
        document.getElementById('limpiarFiltros').addEventListener('click', () => {
            buscar.value = '';
            desde.value = '';
            hasta.value = '';
            filtrar();
        });
    })();
</script>
</body>
</html>