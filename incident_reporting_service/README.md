
# Incident Reporting Service

The Incident Reporting Service provides an API to report and manage incidents. It allows users to create incident reports, view all incident types and subtypes, and interact with incident data in a structured manner.

## Start Command

To start the application, use the following command:

```bash
uvicorn app.main:app --reload --port 8001 --host 0.0.0.0
```

## Routes

### Incident Reporting Routes

The API exposes the following routes under the `/incident` endpoint:

#### 1. Get All Incident Types

**Endpoint**: `/incident/types`  
**Method**: `GET`  
**Description**: Fetches all available incident types.

**Response**:
```json
{
    "types": [/* Array of types */]
}
```

#### 2. Get Incident Subtypes for a Given Type

**Endpoint**: `/incident/{typeID}/subtypes`  
**Method**: `GET`  
**Description**: Fetches all subtypes for a given incident type ID.

**Response**:
```json
{
    "sub_types": [/* Array of subtypes */]
}
```

#### 3. Report an Incident

**Endpoint**: `/incident/report`  
**Method**: `POST`  
**Description**: Allows a user to create a new incident report with all necessary details.

**Request Body**:
```json
{
    "userID": "int",
    "typeID": "int",
    "subtypeID": "int",
    "description": "string",
    "latitude": "float",
    "longitude": "float",
    "place_name": "string"
}
```

**Response**:
```json
{
    "status": "Incident report created successfully",
    "incident": {/* Incident data */}
}
```

