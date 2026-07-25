package mx.edu.utez.awgva;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class HelloServletTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    private HelloServlet servlet;
    private StringWriter responseBody;
    private PrintWriter responseWriter;

    @BeforeEach
    void setUp() {
        servlet = new HelloServlet();
        responseBody = new StringWriter();
        responseWriter = new PrintWriter(responseBody);
    }

    private String writtenBody() {
        responseWriter.flush();
        return responseBody.toString();
    }

    @Test
    void doGetSetsHtmlContentType() throws IOException {
        when(response.getWriter()).thenReturn(responseWriter);

        servlet.init();
        servlet.doGet(request, response);

        verify(response).setContentType("text/html");
    }

    @Test
    void doGetWritesGreetingAfterInit() throws IOException {
        when(response.getWriter()).thenReturn(responseWriter);

        servlet.init();
        servlet.doGet(request, response);

        String body = writtenBody();
        assertTrue(body.contains("<h1>Hello World!</h1>"), body);
        assertTrue(body.startsWith("<html><body>"), body);
        assertTrue(body.trim().endsWith("</body></html>"), body);
    }

    @Test
    void doGetWithoutInitWritesEmptyMessage() throws IOException {
        when(response.getWriter()).thenReturn(responseWriter);

        servlet.doGet(request, response);

        assertTrue(writtenBody().contains("<h1>null</h1>"), writtenBody());
    }

    @Test
    void doGetPropagatesWriterFailure() throws IOException {
        when(response.getWriter()).thenThrow(new IOException("no writer"));

        servlet.init();

        IOException thrown = assertThrows(IOException.class, () -> servlet.doGet(request, response));
        assertEquals("no writer", thrown.getMessage());
    }

    @Test
    void initIsIdempotent() throws IOException {
        when(response.getWriter()).thenReturn(responseWriter);

        servlet.init();
        servlet.init();
        servlet.doGet(request, response);

        assertTrue(writtenBody().contains("Hello World!"));
    }

    @Test
    void destroyDoesNotThrow() {
        servlet.init();
        assertDoesNotThrow(servlet::destroy);
    }
}
