<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Usuarios - UTEZ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Menú Lateral -->
<div class="sidebar">
    <div style="text-align: center; margin-bottom: 20px;">
        <div style="width: 60px; height: 60px; border-radius: 50%; background: #ccc; margin: 0 auto 10px auto;"></div>
        <h3>Nombre Usuario</h3>
    </div>
    <hr>
    <a href="#">🏠 Inicio</a>
    <a href="#">📄 Solicitudes</a>
    <a href="#">📜 Histórico</a>
    <a href="#" style="background: rgba(255,255,255,0.1); font-weight: bold;">👥 Usuarios</a>
    <a href="#">✍️ Firmas</a>
    <br><br>
    <a href="#">🚪 Cerrar sesión</a>
</div>

<!-- Contenido Principal -->
<div class="main-content">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <h2 class="title">Gestión de Usuarios</h2>
        <button class="btn btn-primary">+ Nuevo Usuario</button>
    </div>

    <table class="table-container">
        <thead>
        <tr>
            <th>ID</th>
            <th>Nombre Completo</th>
            <th>Correo Electrónico</th>
            <th>Rol</th>
            <th>Estatus</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>#101</td>
            <td>Juan Pérez Gómez</td>
            <td>juan.perez@utez.edu.mx</td>
            <td>Docente</td>
            <td><span class="badge badge-active">Activo</span></td>
            <td>
                <button class="btn btn-secondary">Editar</button>
                <button class="btn btn-danger">Eliminar</button>
            </td>
        </tr>
        <tr>
            <td>#102</td>
            <td>María López Hernández</td>
            <td>maria.lopez@utez.edu.mx</td>
            <td>Administrador</td>
            <td><span class="badge badge-active">Activo</span></td>
            <td>
                <button class="btn btn-secondary">Editar</button>
                <button class="btn btn-danger">Eliminar</button>
            </td>
        </tr>
        <tr>
            <td>#103</td>
            <td>Carlos Ramos Silva</td>
            <td>carlos.ramos@utez.edu.mx</td>
            <td>Revisor</td>
            <td><span class="badge badge-pending">Inactivo</span></td>
            <td>
                <button class="btn btn-secondary">Editar</button>
                <button class="btn btn-danger">Eliminar</button>
            </td>
        </tr>
        </tbody>
    </table>
</div>

</body>
</html>