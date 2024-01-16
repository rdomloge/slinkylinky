To restore backup, each DB has to exist, they have to be owned by 'slinkylinky', and nobody can be connected, including PGAdmin.

The slinkylinky role must exist in the restore-target and must have the 'create databases' and 'create roles' privileges.

To disconnect PGAdmin, right click on each database and select 'Disconnect from database'

To set the owner of the databases in the restore target, either set it at creation time or right-click and set the owner field.