<%-- 
    Document   : newprovedor
    Created on : 14/10/2024, 08:24:20 PM
    Author     : swoke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agregar Proveedor</title>
</head>
<body>
    <h1>Agregar Proveedor</h1>
    <form action="${pageContext.request.contextPath}/tienda" method="post">
        <input type="hidden" name="action" value="addSupplier">
        <label for="supplierName">Nombre del Proveedor:</label>
        <input type="text" id="supplierName" name="supplierName" required><br>

        <label for="contactEmail">Correo Electrónico:</label>
        <input type="email" id="contactEmail" name="contactEmail" required><br>

        <label for="phoneNumber">Número de Teléfono:</label>
        <input type="text" id="phoneNumber" name="phoneNumber" required><br>

        <input type="submit" value="Agregar Proveedor">
    </form>
</body>
</html>
