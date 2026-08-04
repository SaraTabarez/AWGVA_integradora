package mx.edu.utez.awgva.Model;

import java.text.Normalizer;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/** Catálogo único de carreras permitido por cada división académica. */
public final class CatalogoCarreras {
    private static final Map<String, List<String>> POR_DIVISION = Map.of(
            "DATEFI", List.of(
                    "Licenciatura en Terapia Física",
                    "Licenciatura en Gestión del Bienestar"
            ),
            "DAMI", List.of(
                    "Ingeniería en Mantenimiento Industrial",
                    "Ingeniería en Nanotecnología",
                    "Ingeniería Industrial",
                    "Ingeniería Mecatrónica"
            ),
            "DACEA", List.of(
                    "Licenciatura en Administración",
                    "Licenciatura en Contaduría",
                    "Licenciatura en Negocios y Mercadotecnia"
            ),
            "DATID", List.of(
                    "Ingeniería en Tecnologías de la Información e Innovación Digital",
                    "Diseño Digital y Producción Audiovisual",
                    "Diseño Textil y Moda",
                    "TSU en Infraestructura de Redes Digitales",
                    "TSU en Desarrollo de Software Multiplataforma"
            )
    );

    private CatalogoCarreras() {}

    public static List<String> deDivision(String division) {
        return POR_DIVISION.getOrDefault(claveDivision(division), List.of());
    }

    public static boolean pertenece(String division, String carrera) {
        return carrera != null && deDivision(division).contains(carrera.trim());
    }

    public static String claveDivision(String division) {
        if (division == null) return "";
        String normalizada = Normalizer.normalize(division, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toUpperCase(Locale.ROOT);
        for (String clave : POR_DIVISION.keySet()) {
            if (normalizada.contains(clave)) return clave;
        }
        return normalizada.trim();
    }
}