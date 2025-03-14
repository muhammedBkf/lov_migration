# LOV Migration

## Overview
The `lov_migrator` script is a command-line tool designed to facilitate the migration of [Linked Open Vocabularies (LOV)](https://lov.linkeddata.es/) metadata, agents, and submissions to a specified target portal.

## Usage
The script provides several options to manage different aspects of the migration process.

### Command Syntax
```
./lov_migrator [options]
```

### Available Options
- `--update` : Update metadata.
- `--agents` : Start agents migration.
- `--vocabs` : Migrate vocabularies.
- `--submissions ONTOLOGIES` : Migrate ontology submissions.
- `--target-portal PORTAL` : Specify the target portal for migration.
- `-h, --help` : Display help information.

### Example Commands
To update metadata and migrate all submissions to `LovPortal`:
```
./lov_migrator --update --submissions all --target-portal LovPortal
```

To migrate all agents to `LovPortal`:
```
./lov_migrator --agents all --target-portal LovPortal
```
