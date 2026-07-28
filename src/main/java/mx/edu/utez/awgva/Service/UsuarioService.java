package mx.edu.utez.awgva.Service;

import mx.edu.utez.awgva.Dao.UsuarioDao;
import mx.edu.utez.awgva.Model.Usuario;
import mx.edu.utez.awgva.Utils.EmailSender;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.text.MessageFormat;
import java.util.Random;

public class UsuarioService {

    private UsuarioDao usuarioDao;

    public UsuarioService() {
        this.usuarioDao = new UsuarioDao();
    }

    public Usuario authenticate(String correo, String password) {
        Usuario usuario = usuarioDao.findByEmail(correo);

        if (usuario == null) {
            return null;
        }

        if (usuario.getEstado() == 0) {
            return null;
        }
        String hashedPassword = hashPassword(password);
        if (hashedPassword.equals(usuario.getPasswordHash())) {
            return usuario;
        }
        return null;
    }

    public boolean generateAndSendResetCode(String correo) {
        Usuario usuario = usuarioDao.findByEmail(correo);
        if (usuario == null) {
            return false; // Usuario no encontrado
        }
        String resetToken = generateRandomCode(6);
        long expirationTime = System.currentTimeMillis() + (15 * 60 * 1000);
        Timestamp expiration = new Timestamp(expirationTime);
        boolean updated = usuarioDao.updateResetToken(correo, resetToken, expiration);
        if (!updated) {
            return false;
        }
        String plantillaHtml = """
            <html>
                <body style="font-family: Arial, sans-serif; color: #333333; background-color: #f4f4f4; padding: 20px;">
                    <div style="max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                        <h2 style="color: #0056b3; margin-bottom: 20px;">Recuperación de Contraseña</h2>
                        <p style="font-size: 16px;">Hola, <strong>{0}</strong></p>
                        <p style="font-size: 16px;">Has solicitado recuperar tu contraseña. Tu código de verificación es:</p>
                        <div style="background-color: #0056b3; color: white; font-size: 32px; font-weight: bold; text-align: center; padding: 20px; margin: 20px 0; border-radius: 5px; letter-spacing: 5px;">
                            {1}
                        </div>
                        <p style="font-size: 14px; color: #666;">Este código expirará en <strong>15 minutos</strong>.</p>
                        <p style="font-size: 14px; color: #666;">Si no solicitaste este cambio, puedes ignorar este correo.</p>
                    </div>
                </body>
            </html>
            """;

        String cuerpoCorreo = MessageFormat.format(
                plantillaHtml,
                usuario.getNombreCompleto(),
                resetToken
        );

        try {
            EmailSender.sendMail(correo, "Código de Recuperación de Contraseña", cuerpoCorreo);
            return true;
        } catch (Exception e) {
            System.err.println("Error al enviar correo: " + e.getMessage());
            return false;
        }
    }

    public boolean resetPassword(String token, String newPassword) {
        if (!usuarioDao.isResetTokenValid(token)) {
            return false;
        }

        Usuario usuario = usuarioDao.findByResetToken(token);
        if (usuario == null) {
            return false;
        }
        String hashedPassword = hashPassword(newPassword);
        return usuarioDao.updatePassword(usuario.getCorreo(), hashedPassword);
    }

    private String generateRandomCode(int length) {
        Random random = new SecureRandom();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < length; i++) {
            code.append(random.nextInt(10));
        }
        return code.toString();
    }

    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al hashear contraseña: " + e.getMessage());
        }
    }
}
