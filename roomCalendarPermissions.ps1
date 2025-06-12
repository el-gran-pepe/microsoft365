#Conectar a Exchange OnLine
Connect-ExchangeOnline

#Obtenemos una lista de recursos de sala
Get-Mailbox -RecipientTypeDetails RoomMailbox
#Como segunda opcion es guardarlo en un archivo de texto (opcion si la lista es muy grande)
Get-Mailbox -RecipientTypeDetails RoomMailbox > roomList.txt

#Damos permiso de lectura a un usuario específico para el calendario de una sala
Add-MailboxFolderPermission -Identity "NombreDeLaSala:\Calendar" -User "Usuario@dominio.com" -AccessRights Reviewer
#Debajo detallo todos los permisos posibles a un usuario en casos similares
#'None'             No tiene acceso a la carpeta.
#'AvailabilityOnly' Solo puede ver si el usuario está disponible, ocupado o fuera de la oficina (sin detalles).
#'LimitedDetails'	  Puede ver el asunto y la ubicación, pero no el cuerpo de los eventos.
#'Reviewer'         Puede ver todos los detalles (lector de calendario).
#'Contributor'    	Puede crear elementos pero no puede ver el contenido.
#'NonEditingAuthor'	Puede crear y leer sus propios elementos, pero no puede editar los existentes.
#'Author'	          Puede crear y modificar sus propios elementos.
#'PublishingAuthor'	Igual que 'Author', pero también puede crear subcarpetas.
#'Editor'          	Puede crear, leer, modificar y eliminar sus propios elementos.
#'PublishingEditor'	Igual que 'Editor', pero también puede crear subcarpetas.
#'Owner'          	Tiene control total: puede ver, modificar y administrar permisos.

# Verificamos los permisos actuales del calendario de una sala
Get-MailboxFolderPermission -Identity "NombreDeLaSala:\Calendar"

#Si quisieramos saber los permisos al reves, es decir, ¿En que calendar tiene permiso un usuario? Podriamos usar el siguiente script
$Usuario = "Usuario@dominio.com"
#Guardamos la lista de salas de reuniones
$Salas = Get-Mailbox -RecipientTypeDetails RoomMailbox
#Verificamos los permisos del usuario sobre el calendario de cada sala
foreach ($Sala in $Salas) {
    $Permisos = Get-MailboxFolderPermission -Identity "$($Sala.Identity):\Calendar" -User $Usuario
    if ($Permisos -ne $null) {
        Write-Host "Usuario $($Usuario) tiene permisos $($Permisos.AccessRights) sobre el calendario de la sala $($Sala.Name)"
    } else {
        Write-Host "Usuario $($Usuario) no tiene permisos sobre el calendario de la sala $($Sala.Name)"
    }
}

#BUENAS PRACTICAS
#No se recomienda dar permisos como 'Editor', 'PublishingEditor' o 'Owner' en salas, ya que esto permite modificar o eliminar eventos de otros usuarios, lo cual puede causar problemas con las reservas.
#Los permisos más comunes y seguros para usuarios sobre calendarios de salas son: 'AvailabilityOnly', 'LimitedDetails' o 'Reviewer'
#Evitar crear subcarpetas dentro de un calendario, ya que podria ocasionar dificultad de vision del calendario ya que todos los eventos deberian mostrarse en el calendario principal, y esto puede deberse a que no todos los usuarios tienen los mismos permisos
#y podrian quedar fuera de visibilidad. Tener en cuenta que en el caso de Calendarios, los permisos a las subcarpetas no se heredan.
