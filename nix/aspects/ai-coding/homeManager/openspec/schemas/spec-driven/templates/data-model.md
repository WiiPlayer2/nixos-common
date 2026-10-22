# Data Model

This document describes the data structures needed for the change outlined in [proposal.md](proposal.md), [design.md](design.md), and the [specs](specs/).

## Entities / Types

<!-- List core data entities or types being introduced or modified.
     Each entity should have: name, description, and relationship to other entities. -->

### Entity: <!-- entity name -->
<!-- Description of the entity and its purpose in the system -->

#### Fields
- `field_name`: <!-- field type --> - <!-- description -->

### Entity: <!-- entity name -->
<!-- Description of the entity and its purpose in the system -->

#### Fields
- `field_name`: <!-- field type --> - <!-- description -->

## Relationships

<!-- Describe how entities relate to each other (foreign keys, associations).
     Format: FROM entity TO entity with relationship type. -->

<!-- FROM: <!-- source entity --> | TO: <!-- target entity --> | TYPE: <!-- relationship type --> | DESCRIPTION: <!-- explanation --> -->

## Fields / Properties

<!-- Document key fields with their types, constraints, and meanings.
     Include: name, type, required/optional, default value, constraints. -->

### Field: <!-- field name -->
- **Type**: <!-- data type -->
- **Required**: <!-- true/false -->
- **Default**: <!-- default value or "none" -->
- **Constraints**: <!-- validation rules, formats, ranges -->
- **Description**: <!-- what this field represents -->

## Data Flow

<!-- Describe how data moves through the system.
     Include input data, processing steps, and output data. -->

### Input

<!-- Input data entering the system -->

- **Name**: <!-- input name -->
- **Description**: <!-- what data is being input -->
- **Format**: <!-- expected format -->

### Processing

<!-- Data transformation and processing steps -->

#### Step: <!-- step name -->
<!-- Description of what happens to the data -->

#### Step: <!-- step name -->
<!-- Description of what happens to the data -->

### Output

<!-- Output data leaving the system -->

- **Name**: <!-- output name -->
- **Description**: <!-- what data is being output -->
- **Format**: <!-- expected format -->

## Persistence

<!-- Describe storage requirements.
     Include database tables, file formats, caching strategies. -->

### Storage: <!-- storage type -->
<!-- Description of where data is stored and how -->
- **Type**: <!-- database, file, cache, etc. -->
- **Location**: <!-- where it's stored -->
- **Access Pattern**: <!-- read/write frequency -->
