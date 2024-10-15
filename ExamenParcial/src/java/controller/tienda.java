/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import configuration.ConnectionBD;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author swoke
 */
@WebServlet(name = "tienda", urlPatterns = {"/tienda"})
public class tienda extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        try ( PrintWriter out = response.getWriter()) {
            ConnectionBD connBD = new ConnectionBD();
            Connection connection = connBD.getConnectionBD();

            switch (action) {
                case "addProduct":
                    addProduct(request, response, connection, out);
                    break;
                case "deleteProduct":
                    deleteProduct(request, response, connection, out);
                    break;
                case "showProducts":
                    showProducts(request, response, connection, out);
                    break;
                case "addSupplier":
                    addSupplier(request, response, connection, out);
                    break;
                default:
                    out.println("Acción no válida");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     *
     * @author swoke
     */
    private void addProduct(HttpServletRequest request, HttpServletResponse response, Connection connection, PrintWriter out) throws IOException {
        String productName = request.getParameter("productName");
        String price = request.getParameter("price");
        String stockQuantity = request.getParameter("stockQuantity");
        String supplierId = request.getParameter("supplierId");

        try {
            String query = "INSERT INTO products (name, price, stock_quantity) VALUES (?, ?, ?)";
            PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, productName);
            ps.setString(2, price);
            ps.setString(3, stockQuantity);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int productId = 0;
            if (rs.next()) {
                productId = rs.getInt(1);
            }

            String supplierQuery = "INSERT INTO product_suppliers (product_id, supplier_id) VALUES (?, ?)";
            PreparedStatement psSupplier = connection.prepareStatement(supplierQuery);
            psSupplier.setInt(1, productId);
            psSupplier.setString(2, supplierId);
            psSupplier.executeUpdate();

            out.println("Producto agregado exitosamente");
        } catch (Exception e) {
            out.println("Error al agregar producto: " + e.getMessage());
        }
    }

    /**
     *
     * @author swoke
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response, Connection connection, PrintWriter out) throws IOException {
        String productId = request.getParameter("productId");

        try {
            String query = "DELETE FROM products WHERE product_id = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, productId);
            ps.executeUpdate();

            out.println("Producto eliminado exitosamente");
        } catch (Exception e) {
            out.println("Error al eliminar producto: " + e.getMessage());
        }
    }

    /**
     *
     * @author swoke
     */
    private void showProducts(HttpServletRequest request, HttpServletResponse response, Connection connection, PrintWriter out) throws IOException {
        try {
            String query = "SELECT p.product_id, p.name, p.price, p.stock_quantity, s.supplier_name "
                    + "FROM products p "
                    + "JOIN product_suppliers ps ON p.product_id = ps.product_id "
                    + "JOIN suppliers s ON ps.supplier_id = s.supplier_id";

            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(query);

            out.println("<table border='1'><tr><th>ID</th><th>Producto</th><th>Precio</th><th>Cantidad</th><th>Proveedor</th></tr>");
            while (rs.next()) {
                out.println("<tr><td>" + rs.getInt("product_id") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getDouble("price") + "</td>");
                out.println("<td>" + rs.getInt("stock_quantity") + "</td>");
                out.println("<td>" + rs.getString("supplier_name") + "</td></tr>");
            }
            out.println("</table>");
        } catch (Exception e) {
            out.println("Error al mostrar productos: " + e.getMessage());
        }
    }

    /**
     *
     * @author swoke
     */
    private void addSupplier(HttpServletRequest request, HttpServletResponse response, Connection connection, PrintWriter out) throws IOException {
        String supplierName = request.getParameter("supplierName");
        String contactEmail = request.getParameter("contactEmail");
        String phoneNumber = request.getParameter("phoneNumber");

        try {
            String query = "INSERT INTO suppliers (supplier_name, contact_email, phone_number) VALUES (?, ?, ?)";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, supplierName);
            ps.setString(2, contactEmail);
            ps.setString(3, phoneNumber);
            ps.executeUpdate();

            out.println("Proveedor agregado exitosamente");
        } catch (Exception e) {
            out.println("Error al agregar proveedor: " + e.getMessage());
        }
    }

    /**
     *
     * @author swoke
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     *
     * @author swoke
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Tienda Servlet";
    }
}
