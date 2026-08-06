<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentPath" value="${pageContext.request.requestURI}"/>

<style>
    .sidebar {
        width: 240px;
        height: 100vh;
        position: fixed;
        inset: 0 auto 0 0;
        z-index: 1000;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        padding: 46px 25px 28px;
        box-sizing: border-box;
        background: #1f3d63;
        color: #ffffff;
        font-family: "Segoe UI", Arial, sans-serif;
    }

    .sidebar-profile {
        text-align: center;
        margin-bottom: 48px;
    }

    .sidebar-avatar {
        width: 82px;
        height: 82px;
        margin: 0 auto 15px;
        border-radius: 50%;
        display: grid;
        place-items: center;
        background: #e6e9ed;
        color: #172f4e;
        font-size: 42px;
    }

    .sidebar-role {
        color: #ffffff;
        font-size: .86rem;
        font-weight: 800;
        letter-spacing: .055em;
        text-transform: uppercase;
    }

    .sidebar-nav,
    .sidebar-nav ul {
        width: 100%;
        margin: 0;
        padding: 0;
        list-style: none;
    }

    .sidebar-nav ul {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .sidebar-link,
    .sidebar-logout {
        width: 100%;
        min-height: 42px;
        display: flex;
        align-items: center;
        gap: 13px;
        padding: 9px 11px;
        border: 0;
        border-radius: 6px;
        background: transparent;
        color: #ffffff;
        text-decoration: none;
        text-align: left;
        font: inherit;
        font-size: .91rem;
        font-weight: 650;
        cursor: pointer;
        transition: color .18s ease, background-color .18s ease;
    }

    .sidebar-link i,
    .sidebar-logout i {
        width: 21px;
        text-align: center;
        font-size: 1.05rem;
    }

    .sidebar-link:hover,
    .sidebar-logout:hover {
        color: #ff941f;
        background: rgba(255, 255, 255, .06);
    }

    .sidebar-link.active {
        color: #ff941f;
        background: transparent;
    }

    .sidebar-bottom {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .sidebar-logout-form { margin: 0; }

    @media (max-width: 768px) {
        .sidebar {
            width: 100%;
            height: auto;
            position: static;
            padding: 20px;
        }

        .sidebar-profile { margin-bottom: 18px; }
        .sidebar-avatar { width: 62px; height: 62px; font-size: 31px; }
        .sidebar-bottom { margin-top: 22px; }
    }
</style>

<aside class="sidebar" aria-label="Navegación principal">
    <div>
        <div class="sidebar-profile">
            <div class="sidebar-avatar" aria-hidden="true"><i class="bi bi-person"></i></div>
            <div class="sidebar-role"><c:out value="${sessionScope.rol}"/></div>
        </div>

        <nav class="sidebar-nav">
            <ul>
                <li>
                    <a href="${ctx}/inicio"
                       class="sidebar-link ${fn:endsWith(currentPath, '/inicio') ? 'active' : ''}">
                        <i class="bi bi-house-door"></i><span>Inicio</span>
                    </a>
                </li>

                <c:choose>
                    <c:when test="${sessionScope.rol == 'DOCENTE'}">
                        <li><a href="${ctx}/mis-solicitudes" class="sidebar-link ${fn:contains(currentPath, 'solicitud') ? 'active' : ''}"><i class="bi bi-file-earmark-text"></i><span>Solicitud</span></a></li>
                        <li><a href="${ctx}/reportes-docente" class="sidebar-link ${fn:contains(currentPath, 'reportes-docente') ? 'active' : ''}"><i class="bi bi-file-earmark-bar-graph"></i><span>Reporte</span></a></li>
                        <li><a href="${ctx}/historico-docente" class="sidebar-link ${fn:contains(currentPath, 'historico-docente') ? 'active' : ''}"><i class="bi bi-clock-history"></i><span>Histórico</span></a></li>
                    </c:when>

                    <c:when test="${sessionScope.rol == 'DIRECTOR'}">
                        <li><a href="${ctx}/director/solicitudes" class="sidebar-link ${fn:contains(currentPath, '/director/solicitud') ? 'active' : ''}"><i class="bi bi-file-earmark-check"></i><span>Solicitudes</span></a></li>
                        <li><a href="${ctx}/director/historico" class="sidebar-link ${fn:contains(currentPath, '/director/historico') ? 'active' : ''}"><i class="bi bi-clock-history"></i><span>Histórico</span></a></li>
                    </c:when>

                    <c:when test="${sessionScope.rol == 'ESTADIAS'}">
                        <li><a href="${ctx}/estadias/documentos" class="sidebar-link ${fn:contains(currentPath, '/estadias/document') ? 'active' : ''}"><i class="bi bi-folder2-open"></i><span>Gestión de archivos</span></a></li>
                        <li><a href="${ctx}/estadias/historico" class="sidebar-link ${fn:contains(currentPath, '/estadias/historico') ? 'active' : ''}"><i class="bi bi-clock-history"></i><span>Histórico</span></a></li>
                    </c:when>

                    <c:when test="${sessionScope.rol == 'ADMIN'}">
                        <li><a href="${ctx}/GestionUsuariosServlet" class="sidebar-link ${fn:contains(currentPath, 'Usuario') || fn:contains(currentPath, 'usuario') ? 'active' : ''}"><i class="bi bi-people"></i><span>Usuarios</span></a></li>
                        <li><a href="${ctx}/RegistrarUsuarioServlet" class="sidebar-link"><i class="bi bi-person-plus"></i><span>Registrar usuario</span></a></li>
                    </c:when>
                </c:choose>
            </ul>
        </nav>
    </div>

    <div class="sidebar-bottom">
        <c:if test="${sessionScope.rol == 'DIRECTOR'}">
            <a href="${ctx}/cambiar-contrasena" class="sidebar-link ${fn:contains(currentPath, 'cambiar-contrasena') ? 'active' : ''}">
                <i class="bi bi-key"></i><span>Cambiar contraseña</span>
            </a>
        </c:if>

        <form method="post" action="${ctx}/logout" class="sidebar-logout-form">
            <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>"/>
            <button type="submit" class="sidebar-logout">
                <i class="bi bi-box-arrow-right"></i><span>Cerrar sesión</span>
            </button>
        </form>
    </div>
</aside>