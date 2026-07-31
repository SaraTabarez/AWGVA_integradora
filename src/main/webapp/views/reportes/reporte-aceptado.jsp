<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte Aceptado</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; text-align: center; padding-top: 50px; }
        .card { background: white; width: 500px; margin: auto; padding: 40px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .icon { font-size: 60px; color: #2e7d32; }
        h1 { color: #2e7d32; margin-top: 10px; }
        .btn { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #1e3a5f; color: white; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>

<div class="card">
    <div class="icon">✓</div>
    <h1>¡Reporte Aceptado!</h1>
    <p style="margin-top:15px; color:#555;">El reporte de la visita a <strong>${sessionScope.empresa}</strong> ha sido validado satisfactoriamente por la coordinación de Estadías.</p>
    <a href="${pageContext.request.contextPath}/views/reportes/detalles-reporte.jsp" class="btn">Volver a Detalles</a>
</div>

</body>
</html>