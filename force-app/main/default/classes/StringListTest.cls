public class StringListTest {

    // Método estático público que devuelve una lista de Strings
    public static List<String> generateStringList(Integer n) {
        // 1. Inicializamos la lista de cadenas
        List<String> myList = new List<String>();

        // 2. Usamos un bucle for que se repita 'n' veces
        for(Integer i = 0; i < n; i++) {
            // 3. Agregamos el texto con el formato solicitado: Test + espacio + índice
            myList.add('Test ' + i);
        }

        // 4. Devolvemos la lista completa
        return myList;
    }
}