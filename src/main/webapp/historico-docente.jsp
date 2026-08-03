<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vista Histórico Docente</title>
    <!-- Integración de Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- Integración de Flatpickr (Calendario) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Ajuste para despejar la sidebar fija (ancho 240px) */
        .main-layout {
            margin-left: 240px;
            padding: 2.5rem 3rem;
            min-height: 100vh;
        }

        .table-header-dark { background-color: #2b2d42; color: white; }
        .btn-custom-dark { background-color: #2b2d42; color: white; border: none; }
        .btn-custom-dark:hover { background-color: #1a1b26; color: white; }
        .page-item.active .page-link { background-color: #f39c12; border-color: #f39c12; }
        .page-link { color: #6c757d; }
        .date-icon { cursor: pointer; }

        @media (max-width: 768px) {
            .main-layout {
                margin-left: 0;
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>

<!-- Menú lateral importado directamente (posición fija) -->
<jsp:include page="Layout/sidebar.jsp"/>

<!-- Contenido Principal Desplazado -->
<main class="main-layout">
    <h3 class="mb-4 fw-bold" style="color: #2b2d42;">HISTORIAL DE SOLICITUDES</h3>

    <!-- Filtros -->
    <div class="row mb-4 align-items-end g-3">
        <div class="col-md-5">
            <div class="input-group">
                <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                <input type="text" id="busqueda-docente" class="form-control" placeholder="Buscar por ID, Lugar....">
            </div>
        </div>
        <div class="col-md-5">
            <label class="form-label fw-bold small">Fecha:</label>
            <div class="input-group">
                <input type="text" class="form-control date-picker" placeholder="Desde" id="fecha-desde-docente">
                <span class="input-group-text bg-white date-icon" onclick="document.getElementById('fecha-desde-docente')._flatpickr.open()"><i class="bi bi-calendar3"></i></span>

                <input type="text" class="form-control date-picker" placeholder="Hasta" id="fecha-hasta-docente">
                <span class="input-group-text bg-white date-icon" onclick="document.getElementById('fecha-hasta-docente')._flatpickr.open()"><i class="bi bi-calendar3"></i></span>
            </div>
        </div>
        <div class="col-md-2 text-end">
            <button type="button" class="btn btn-custom-dark w-100" onclick="limpiarFiltrosDocente()">LIMPIAR FILTROS</button>
        </div>
    </div>

    <!-- Tabla -->
    <div class="table-responsive bg-white rounded shadow-sm p-3">
        <table class="table table-hover align-middle text-center mb-0">
            <thead class="table-header-dark">
            <tr>
                <th>ID</th>
                <th>EMPRESA</th>
                <th>LUGAR</th>
                <th>FECHA</th>
                <th>CARRERA</th>
                <th>GRUPO</th>
                <th>ACCIONES</th>
            </tr>
            </thead>
            <tbody>
            <tr id="fila-1010">
                <td>1010</td><td>NISSAN</td><td>MORELOS</td><td>25-08-26</td><td>INGENIERÍA MECATRÓNICA</td><td>6°B</td>
                <td><button class="btn btn-custom-dark btn-sm px-4" onclick="verDetalle('1010')"><i class="bi bi-eye"></i></button></td>
            </tr>
            <tr id="fila-1011">
                <td>1011</td><td>ORACLE</td><td>MORELOS</td><td>30-07-26</td><td>INGENIERÍA INDUSTRIAL</td><td>6°A</td>
                <td><button class="btn btn-custom-dark btn-sm px-4" onclick="verDetalle('1011')"><i class="bi bi-eye"></i></button></td>
            </tr>
            <tr id="fila-1012">
                <td>1012</td><td>BIMBO</td><td>TOLUCA</td><td>28-07-26</td><td>INGENIERÍA SISTEMAS</td><td>6°B</td>
                <td><button class="btn btn-custom-dark btn-sm px-4" onclick="verDetalle('1012')"><i class="bi bi-eye"></i></button></td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- Paginación -->
    <div class="d-flex justify-content-between align-items-center mt-4">
        <nav>
            <ul class="pagination mb-0">
                <li class="page-item disabled"><a class="page-link" href="#">Anterior</a></li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item disabled"><a class="page-link" href="#">...</a></li>
                <li class="page-item"><a class="page-link" href="#">Siguiente</a></li>
            </ul>
        </nav>
        <small class="fw-bold text-secondary">Mostrando 1 de 10 de 125 solicitudes</small>
    </div>
</main>

<!-- Modal Dinámico para Detalle de Solicitud -->
<div class="modal fade" id="modalDetalle" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title" id="modalDetalleTitulo">Detalle de Solicitud</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="modalDetalleCuerpo">
                <!-- El contenido se genera con JavaScript -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<!-- Scripts de Bootstrap y Flatpickr -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://npmcdn.com/flatpickr/dist/l10n/es.js"></script>

<script>
    // 1. Inicializar calendarios guardados en variables
    const fpDesde = flatpickr("#fecha-desde-docente", { locale: "es", dateFormat: "d-m-Y", allowInput: true, onChange: filtrarTabla });
    const fpHasta = flatpickr("#fecha-hasta-docente", { locale: "es", dateFormat: "d-m-Y", allowInput: true, onChange: filtrarTabla });

    // 2. Evento para Búsqueda por Texto
    document.getElementById("busqueda-docente").addEventListener("keyup", filtrarTabla);

    // 3. Función Principal de Filtrado (Texto + Fechas)
    function filtrarTabla() {
        let texto = document.getElementById("busqueda-docente").value.toLowerCase();
        let fechaDesdeVal = document.getElementById("fecha-desde-docente").value;
        let fechaHastaVal = document.getElementById("fecha-hasta-docente").value;

        let filas = document.querySelectorAll("tbody tr");

        filas.forEach(function(fila) {
            let textoFila = fila.textContent.toLowerCase();
            let fechaFilaTexto = fila.children[3].textContent.trim();

            let coincideTexto = textoFila.includes(texto);
            let coincideFecha = true;

            if (fechaDesdeVal || fechaHastaVal) {
                let partes = fechaFilaTexto.split('-');
                let anio = parseInt(partes[2]) < 100 ? 2000 + parseInt(partes[2]) : parseInt(partes[2]);
                let fechaFila = new Date(anio, parseInt(partes[1]) - 1, parseInt(partes[0]));

                if (fechaDesdeVal) {
                    let pD = fechaDesdeVal.split('-');
                    let fD = new Date(pD[2], pD[1] - 1, pD[0]);
                    if (fechaFila < fD) coincideFecha = false;
                }
                if (fechaHastaVal) {
                    let pH = fechaHastaVal.split('-');
                    let fH = new Date(pH[2], pH[1] - 1, pH[0]);
                    if (fechaFila > fH) coincideFecha = false;
                }
            }

            if (coincideTexto && coincideFecha) {
                fila.style.display = "";
            } else {
                fila.style.display = "none";
            }
        });
    }

    // 4. Limpiar Filtros
    function limpiarFiltrosDocente() {
        document.getElementById('busqueda-docente').value = '';
        fpDesde.clear();
        fpHasta.clear();
        let filas = document.querySelectorAll("tbody tr");
        filas.forEach(fila => fila.style.display = "");
    }

    // 5. Ver Detalle de la Solicitud
    function verDetalle(id) {
        let fila = document.getElementById("fila-" + id);
        let c = fila.children;

        document.getElementById("modalDetalleTitulo").innerText = "Detalle de Solicitud #" + id;

        let modalCuerpo = document.getElementById("modalDetalleCuerpo");
        modalCuerpo.innerHTML = `
            <p><strong>ID:</strong> ${c[0].textContent}</p>
            <p><strong>Empresa:</strong> ${c[1].textContent}</p>
            <p><strong>Lugar:</strong> ${c[2].textContent}</p>
            <p><strong>Fecha de Visita:</strong> ${c[3].textContent}</p>
            <p><strong>Carrera:</strong> ${c[4].textContent}</p>
            <p><strong>Grupo:</strong> ${c[5].textContent}</p>
            <p><strong>Estado:</strong> <span class="badge bg-success">Completado / Histórico</span></p>
        `;

        let modal = new bootstrap.Modal(document.getElementById('modalDetalle'));
        modal.show();
    }
</script>
</body>
</html>