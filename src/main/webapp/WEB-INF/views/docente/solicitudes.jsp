<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 04/08/2026
  Time: 08:37 a. m.
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
    <title>Mis solicitudes - AWGVA</title>
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
            <h1 class="page-title">Mis solicitudes</h1>
            <p class="page-subtitle">Sólo se muestran las solicitudes creadas por tu cuenta.</p>
        </div>
        <a class="btn-orange" href="${ctx}/nueva-solicitud"><i class="bi bi-plus-circle"></i>Nueva solicitud</a>
    </header>

    <c:if test="${param.creada == '1'}">
        <div class="alert-success-soft"><i class="bi bi-check-circle"></i> Solicitud registrada y enviada a Dirección.</div>
    </c:if>

    <section class="panel">
        <c:choose>
            <c:when test="${empty solicitudes}">
                <div class="empty"><i class="bi bi-inbox"></i>No tienes solicitudes registradas.</div>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="portal-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Empresa</th>
                            <th>Carrera</th>
                            <th>Fecha</th>
                            <th>Estado</th>
                            <th>Acción</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${solicitudes}">
                            <tr>
                                <td>#<c:out value="${item.idVisita}"/></td>
                                <td><c:out value="${item.empresa}"/></td>
                                <td><c:out value="${item.carrera}"/></td>
                                <td><c:out value="${item.fechaInicio}"/></td>
                                <td>
                                            <span class="status" data-state="${item.estado}">
                                                <c:out value="${item.estadoLegible}"/>
                                            </span>
                                </td>
                                <td>
                                    <a class="btn-navy" href="${ctx}/detalle-solicitud?id=${item.idVisita}" aria-label="Ver detalle">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>
</body>
</html>