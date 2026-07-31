// Funciones para abrir y cerrar modales de confirmación
function abrirModalAceptar() {
    document.getElementById('modalAceptar').style.display = 'flex';
}

function cerrarModalAceptar() {
    document.getElementById('modalAceptar').style.display = 'none';
}

function abrirModalRechazar() {
    document.getElementById('modalRechazar').style.display = 'flex';
}

function cerrarModalRechazar() {
    document.getElementById('modalRechazar').style.display = 'none';
}

function abrirModalDocenteAceptado() {
    var modal = document.getElementById('modalDocenteAceptado');
    if (modal) modal.style.display = 'flex';
}

function abrirModalDocenteRechazado() {
    var modal = document.getElementById('modalDocenteRechazado');
    if (modal) modal.style.display = 'flex';
}