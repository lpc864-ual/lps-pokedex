//
//  CoreDataManager.swift
//  LPS
//
//  Created by Aula03 on 26/11/24.
//

import CoreData

class CoreDataManager {

    // Singleton
    static let instance = CoreDataManager()

    // NSPersistentContainer y contexto de Core Data
    let contenedor: NSPersistentContainer
    let contexto: NSManagedObjectContext

    init() {
        contenedor = NSPersistentContainer(name: "PokedexModel")
        contenedor.loadPersistentStores { (descripcion, error) in
            if let error = error {
                print("Error al cargar datos de Core Data: \(error)")
            } else {
                print("Carga de datos correcta")
            }
        }
        contexto = contenedor.viewContext
    }
    
    // Método para guardar los cambios en el contexto de Core Data
    func save() {
        do {
            try contexto.save()
            print("Datos almacenados correctamente")
        } catch let error {
            print("Error al guardar datos \(error)")
        }
    }
    
    // Método auxiliar para obtener un usuario por su nombre de usuario
    private func getUser(username: String) -> PersonaEntity? {
        let request: NSFetchRequest<PersonaEntity> =
            PersonaEntity.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)

        do {
            let results = try contexto.fetch(request)
            return results.first
        } catch let error {
            print("Error al buscar usuario: \(error)")
            return nil
        }
    }

    // Método para verificar si un usuario existe con las credenciales proporcionadas (login)
    func loginUser(username: String, password: String) -> String
    {
        // Buscamos al usuario en el contexto por el nombre de usuario
        if let user = getUser(username: username) {
            // Comparamos las contraseñas
            if user.password == password {
                print("Inicio de sesión exitoso para \(username).")
                return "Inicio de sesión exitoso."
            } else {
                print("Contraseña incorrecta.")
                return "Contraseña incorrecta."
            }
        } else {
            print("Usuario no encontrado.")
            return "Usuario no encontrado."
        }
    }
    
    // Método para registrar un nuevo usuario
    func registerUser(username: String, password: String) -> String {
        // Verificamos si el usuario ya existe
        if let existingUser = getUser(username: username) {
            print("El usuario \(username) ya existe.")
            return "El usuario \(username) ya existe."
        }

        // Creamos una nueva instancia de PersonaEntity
        let newUser = PersonaEntity(context: contexto)
        newUser.username = username
        newUser.password = password

        // Guardamos los cambios
        save()
        print("Usuario \(username) registrado correctamente.")
        return "Registro exitoso."
    }
    
    // Método para eliminar todos los usuarios
    func deleteAllUsers() {
        let context = CoreDataManager.instance.contexto
        
        // 1. Crear una solicitud de eliminación (delete request)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PersonaEntity.fetchRequest()
        
        // 2. Crear una solicitud de eliminación para los resultados de la consulta
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            // 3. Ejecutar la solicitud de eliminación en el contexto
            try context.execute(deleteRequest)
            print("Todos los usuarios han sido eliminados.")
            
            // 4. Guardar los cambios en el contexto para asegurar que se persistan
            try context.save()
        } catch let error {
            print("Error al eliminar todos los usuarios: \(error)")
        }
    }

}
