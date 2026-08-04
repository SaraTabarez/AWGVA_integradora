<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 04/08/2026
  Time: 08:38 a. m.
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
    <title>Histórico de Estadías - AWGVA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${ctx}/assets/css/portal.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/Layout/sidebar.jsp"/>

<main class="portal-main">
    <header class="page-top">
        <div>
            <div class="eyebrow">Panel de Estadías</div>
            <h1 class="page-title">Histórico de todas las visitas recibidas</h1>
            <p class="page-subtitle">Incluye cada visita que tenga al menos uno de los tres documentos recibidos, sin limitar la división.</p>
        </div>
    </header>

    <form class="panel toolbar" method="get" action="${ctx}/estadias/historico">
        <div class="grow">
            <input class="form-control" name="q" value="<c:out value='${param.q}'/>" placeholder="ID, empresa, división o carrera">
        </div>
        <button class="btn-orange" type="submit">Buscar</button>
    </form>

    <section class="panel">
        <c:choose>
            <c:when test="${empty solicitudes}">
                <div class="empty"><i class="bi bi-clock-history"></i>No existen visitas recibidas.</div>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="portal-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Empresa</th>
                            <th>Docente</th>
                            <th>División</th>
                            <th>Carrera</th>
                            <th>Fecha</th>
                            <th>Estado</th>
                            <th>Detalle</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${solicitudes}">
                            <tr>
                                <td>#<c:out value="${item.idVisita}"/></td>
                                <td><c:out value="${item.empresa}"/></td>
                                <td><c:out value="${item.docente}"/></td>
                                <td><c:out value="${item.division}"/></td>
                                <td><c:out value="${item.carrera}"/></td>
                                <td><c:out value="${item.fechaInicio}"/></td>
                                <td>
                                            <span class="status" data-state="${item.estado}">
                                                <c:out value="${item.estadoLegible}"/>
                                            </span>
                                </td>
                                <td>
                                    <a class="btn-navy" href="${ctx}/estadias/documento?id=${item.idVisita}">
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