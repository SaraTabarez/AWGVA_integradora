<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentPath" value="${pageContext.request.requestURI}"/>

<style>
    .sidebar {
        width: 240px;
        background-color: #1e3a5f;
        color: #ffffff;
        padding: 32px 20px 24px;
        height: 100vh;
        position: fixed;
        inset: 0 auto 0 0;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        z-index: 1000;
        box-sizing: border-box;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }
    .sidebar .user-profile { text-align: center; margin-bottom: 32px; }
    .sidebar .avatar {
        width: 76px; height: 76px; margin: 0 auto 14px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        background: #dbe4ee; color: #1e3a5f; font-size: 38px;
    }
    .sidebar .user-name { font-weight: 700; font-size: .92rem; line-height: 1.25; }
    .sidebar .user-role { color: #ffad5c; font-size: .76rem; font-weight: 800; letter-spacing: 1px; margin-top: 5px; }
    .sidebar ul { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 7px; }
    .sidebar .nav-link-role, .sidebar .logout-button {
        width: 100%; border: 0; color: #fff; background: transparent; text-decoration: none;
        display: flex; align-items: center; gap: 12px; padding: 10px 12px;
        border-radius: 7px; font-weight: 650; font-size: .91rem; text-align: left;
    }
    .sidebar .nav-link-role:hover, .sidebar .nav-link-role.active, .sidebar .logout-button:hover {
        background: rgba(255, 255, 255, .14); color: #fff;
    }
    .sidebar .nav-link-role i, .sidebar .logout-button i { width: 22px; text-align: center; font-size: 1.12rem; }
    .sidebar .logout-form { margin: 0; }
    .sidebar .logout-button { cursor: pointer; }
    @media (max-width: 768px) {
        .sidebar { position: static; width: 100%; height: auto; padding: 18px; }
        .sidebar .user-profile { margin-bottom: 16px; }
        .sidebar .avatar { width: 58px; height: 58px; font-size: 28px; }
    }
</style>

<aside class="sidebar" aria-label="Navegación principal">
    <div>
        <div class="user-profile">
            <div class="avatar" aria-hidden="true"><i class="bi bi-person"></i></div>
            <div class="user-name"><c:out value="${sessionScope.nombreUsuario}"/></div>
            <div class="user-role"><c:out value="${sessionScope.rol}"/></div>
        </div>

        <nav>
            <ul>
                <li>
                    <a href="${ctx}/inicio" class="nav-link-role ${fn:endsWith(currentPath, '/inicio') ? 'active' : ''}">
                        <i class="bi bi-house-door"></i><span>Inicio</span>
                    </a>
                </li>

                <c:choose>
                    <c:when test="${sessionScope.rol == 'DOCENTE'}">
                        <li><a href="${ctx}/solicitud.jsp" class="nav-link-role ${fn:contains(currentPath, 'solicitud') ? 'active' : ''}"><i class="bi bi-file-earmark-text"></i><span>Solicitudes</span></a></li>
                        <li><a href="${ctx}/subir-docs.jsp" class="nav-link-role ${fn:contains(currentPath, 'subir-docs') ? 'active' : ''}"><i class="bi bi-cloud-arrow-up"></i><span>Reportes</span></a></li>
                        <li><a href="${ctx}/historico-docente.jsp" class="nav-link-role ${fn:contains(currentPath, 'historico-docente') ? 'active' : ''}"><i class="bi bi-clock-history"></i><span>Histórico</span></a></li>
                    </c:when>

                    <c:when test="${sessionScope.rol == 'DIRECTOR'}">
                        <li><a href="${ctx}/servlet-gestion-solicitudes" class="nav-link-role ${fn:contains(currentPath, 'gestion-solicitudes') ? 'active' : ''}"><i class="bi bi-clipboard-check"></i><span>Revisar solicitudes</span></a></li>
                    </c:when>

                    <c:when test="${sessionScope.rol == 'ESTADIAS'}">
                        <li><a href="${ctx}/gestion-documentos.jsp" class="nav-link-role ${fn:contains(currentPath, 'gestion-documentos') ? 'active' : ''}"><i class="bi bi-folder-check"></i><span>Documentos</span></a></li>
                        <li><a href="${ctx}/revisar-reporte.jsp" class="nav-link-role ${fn:contains(currentPath, 'revisar-reporte') ? 'active' : ''}"><i class="bi bi-journal-check"></i><span>Revisar reportes</span></a></li>
                        <li><a href="${ctx}/historico-estadias.jsp" class="nav-link-role ${fn:contains(currentPath, 'historico-estadias') ? 'active' : ''}"><i class="bi bi-clock-history"></i><span>Histórico</span></a></li>
                    </c:when>

                    <c:when test="${sessionScope.rol == 'ADMIN'}">
                        <li><a href="${ctx}/servlet-gestion-solicitudes" class="nav-link-role"><i class="bi bi-clipboard-check"></i><span>Solicitudes</span></a></li>
                        <li><a href="${ctx}/gestion-documentos.jsp" class="nav-link-role"><i class="bi bi-folder-check"></i><span>Documentos</span></a></li>
                        <li><a href="${ctx}/revisar-reporte.jsp" class="nav-link-role"><i class="bi bi-journal-check"></i><span>Reportes</span></a></li>
                        <li><a href="${ctx}/GestionUsuariosServlet" class="nav-link-role ${fn:contains(currentPath, 'Usuario') || fn:contains(currentPath, 'usuario') ? 'active' : ''}"><i class="bi bi-people"></i><span>Usuarios</span></a></li>
                    </c:when>
                </c:choose>
            </ul>
        </nav>
    </div>

    <form method="post" action="${ctx}/logout" class="logout-form">
        <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>"/>
        <button type="submit" class="logout-button">
            <i class="bi bi-box-arrow-left"></i><span>Cerrar sesión</span>
        </button>
    </form>
</aside>
