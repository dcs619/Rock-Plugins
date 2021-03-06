------------------------------------------------------------------------
-- This script adds data for the attended checkin workflow
------------------------------------------------------------------------

BEGIN TRANSACTION 

------------------------------------------------------------------------
-- Workflow Data
------------------------------------------------------------------------
DECLARE @WorkflowTypeEntityTypeId int
SET @WorkflowTypeEntityTypeId = (SELECT Id FROM EntityType WHERE Name = 'Rock.Model.WorkflowType')

-- Category Type
DECLARE @CategoryId int
SELECT @CategoryId = [Id] FROM Category 
WHERE [Name] = 'Check-in' AND [EntityTypeId] = @WorkflowTypeEntityTypeId

-- Person Entity Type
DECLARE @PersonEntityTypeId int
SET @PersonEntityTypeId = (SELECT Id FROM EntityType WHERE Name = 'Rock.Model.Person')

-- Workflow Type
DECLARE @WorkflowTypeId int
SET @WorkflowTypeId = (SELECT Id FROM [WorkflowType] WHERE Guid = '6E8CD562-A1DA-4E13-A45C-853DB56E0014')
IF @WorkflowTypeId IS NOT NULL
BEGIN
	DELETE [Workflow] WHERE Id = @WorkflowTypeId
	DELETE [WorkflowType] WHERE Id = @WorkflowTypeId
END

INSERT INTO WorkFlowType ([IsSystem], [IsActive], [Name], [Description], [CategoryId], [Order], [WorkTerm], [IsPersisted], [LoggingLevel], [Guid])
VALUES (0, 1, 'Attended Check-in', 'Workflow for managing attended check-in', @CategoryId, 0, 'Check-in', 0, 3, '6E8CD562-A1DA-4E13-A45C-853DB56E0014')
SET @WorkflowTypeId = SCOPE_IDENTITY()

-- Workflow Entity Type
IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Model.Workflow')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Model.Workflow', NEWID(), 0, 0, 0)
DECLARE @WorkflowEntityTypeId int
SET @WorkflowEntityTypeId = (SELECT Id FROM EntityType WHERE Name = 'Rock.Model.Workflow')

DECLARE @WorkflowActivity1 int
DECLARE @WorkflowActivity2 int
DECLARE @WorkflowActivity3 int
DECLARE @WorkflowActivity4 int
INSERT WorkflowActivityType ([IsActive], [WorkflowTypeId], [Name], [Description], [IsActivatedWithWorkflow], [Order], [Guid])
VALUES ( 1, @WorkflowTypeId,	'Family Search',	 '', 0, 0, 'B6FC7350-10E0-4255-873D-4B492B7D27FF') 
	, ( 1, @WorkflowTypeId, 'Person Search', '', 0, 1,	 '6D8CC755-0140-439A-B5A3-97D2F7681697')
	, ( 1, @WorkflowTypeId, 'Activity Search', '', 0, 2,	 '77CCAF74-AC78-45DE-8BF9-4C544B54C9DD')
	, ( 	1, @WorkflowTypeId, 'Save Attendance', '', 0, 4,	 'BF4E1CAA-25A3-4676-BCA2-FDE2C07E8210')

SELECT @WorkflowActivity1 = Id FROM WorkflowActivityType 
	WHERE Guid = 'B6FC7350-10E0-4255-873D-4B492B7D27FF'
SELECT @WorkflowActivity2 = Id FROM WorkflowActivityType 
	WHERE Guid = '6D8CC755-0140-439A-B5A3-97D2F7681697'
SELECT @WorkflowActivity3 = Id FROM WorkflowActivityType 
	WHERE Guid = '77CCAF74-AC78-45DE-8BF9-4C544B54C9DD'
SELECT @WorkflowActivity4 = Id FROM WorkflowActivityType 
	WHERE Guid = 'BF4E1CAA-25A3-4676-BCA2-FDE2C07E8210'

-- Workflow Action Entity Types
IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterActiveLocations')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.FilterActiveLocations', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterByAge')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.FilterByAge', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindFamilies')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.FindFamilies', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindFamilyMembers')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.FindFamilyMembers', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindRelationships')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.FindRelationships', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadGroups')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.LoadGroups', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadGroupTypes')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.LoadGroupTypes', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadLocations')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.LoadLocations', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadSchedules')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.LoadSchedules', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyGroups')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.RemoveEmptyGroups', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyGroupTypes')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.RemoveEmptyGroupTypes', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyLocations')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.RemoveEmptyLocations', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyPeople')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.RemoveEmptyPeople', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.SaveAttendance')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.SaveAttendance', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.CreateLabels')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.CreateLabels', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.CalculateLastAttended')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.CalculateLastAttended', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterGroupsByAbilityLevel')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.FilterGroupsByAbilityLevel', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.SelectByLastAttended')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.SelectByLastAttended', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.SelectByBestFit')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.SelectByBestFit', NEWID(), 0, 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterGroupsByGender')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured, IsCommon)
VALUES ('Rock.Workflow.Action.CheckIn.FilterGroupsByGender', NEWID(), 0, 0, 0)

DECLARE @LoadGroupsActionId int
DECLARE @LoadLocationsActionId int
DECLARE @LoadSchedulesActionId int

-- Family Search
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity1, 'Find Families', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindFamilies'

-- Person Search
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Find Family Members', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindFamilyMembers'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Find Relationships', 1, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindRelationships'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Load Group Types', 2, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadGroupTypes'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Filter by Age', 3, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterByAge'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Remove Empty People', 4, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyPeople'

-- Activity
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Load Groups', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadGroups'
SET @LoadGroupsActionId = SCOPE_IDENTITY()
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Load Locations', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadLocations'
SET @LoadLocationsActionId = SCOPE_IDENTITY()
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Load Schedules', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadSchedules'
SET @LoadSchedulesActionId = SCOPE_IDENTITY()
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Filter Active Locations', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterActiveLocations'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Filter Groups By Gender', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterGroupsByGender'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Filter Groups By Ability Level', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterGroupsByAbilityLevel'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Remove Empty Groups', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyGroups'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Calculate Last Attended', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.CalculateLastAttended'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Select By Last Attended', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.SelectByLastAttended'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Select By Best Fit', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.SelectByBestFit'

-- Confirm 
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity4, 'Save Attendance', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.SaveAttendance'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity4, 'Create Labels', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.CreateLabels'

-- Set AttributeValues for LoadGroups, LoadLocations, LoadSchedules
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, Value, Guid) 
SELECT 0, [Id], @LoadGroupsActionId, 'True', NEWID() FROM Attribute WHERE [Guid] = '39762EF0-91D5-4B13-BD34-FC3AC3C24897'

INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, Value, Guid) 
SELECT 0, [Id], @LoadLocationsActionId, 'True', NEWID() FROM Attribute WHERE [Guid] = '70203A96-AE70-47AD-A086-FD84792DF2B6'

INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, Value, Guid) 
SELECT 0, [Id], @LoadSchedulesActionId, 'True', NEWID() FROM Attribute WHERE [Guid] = 'B222CAF2-DF12-433C-B5D4-A8DB95B60207'

-- Look up BlockAttributes and Blocks for Attended Check-in
DECLARE @AttributeAdmin int
SELECT @AttributeAdmin = [ID] from [Attribute] where [Guid] = '18864DE7-F075-437D-BA72-A6054C209FA5'
DECLARE @AttributeSearch int
SELECT @AttributeSearch = [ID] from [Attribute] where [Guid] = 'C4E992EA-62AE-4211-BE5A-9EEF5131235C'
DECLARE @AttributeFamily int
SELECT @AttributeFamily = [ID] from [Attribute] where [Guid] = '338CAD91-3272-465B-B768-0AC2F07A0B40'
DECLARE @AttributeActivity int
SELECT @AttributeActivity = [ID] from [Attribute] where [Guid] = 'BEC10B87-4B19-4CD5-8952-A4D59DDA3E9C'
DECLARE @AttributeConfirmation int
SELECT @AttributeConfirmation = [ID] from [Attribute] where [Guid] = '2A71729F-E7CA-4ACD-9996-A6A661A069FD'

DECLARE @EntityIdAdmin int
SELECT @EntityIdAdmin = [ID] from [Block] where [Guid] = '9F8731AB-07DB-406F-A344-45E31D0DE301'
DECLARE @EntityIdSearch int
SELECT @EntityIdSearch = [ID] from [Block] where [Guid] = '182C9AA0-E76F-4AAF-9F61-5418EE5A0CDB'
DECLARE @EntityIdFamily int
SELECT @EntityIdFamily = [ID] from [Block] where [Guid] = '82929409-8551-413C-972A-98EDBC23F420'
DECLARE @EntityIdActivity int
SELECT @EntityIdActivity = [ID] from [Block] where [Guid] = '8C8CBBE9-2502-4FEC-804D-C0DA13C07FA4'
DECLARE @EntityIdConfirmation int
SELECT @EntityIdConfirmation = [ID] from [Block] where [Guid] = '7CC68DD4-A6EF-4B67-9FEA-A144C479E058'

-- Update current check-in blocks with new Workflow id
DELETE AttributeValue WHERE AttributeId = @AttributeAdmin
DELETE AttributeValue WHERE AttributeId = @AttributeSearch
DELETE AttributeValue WHERE AttributeId = @AttributeFamily
DELETE AttributeValue WHERE AttributeId = @AttributeActivity
DELETE AttributeValue WHERE AttributeId = @AttributeConfirmation

INSERT [AttributeValue] ([IsSystem], [AttributeId], [EntityId], [Order], [Value], [Guid])
VALUES (1, @AttributeAdmin, @EntityIdAdmin, 0, @WorkflowTypeId, '6CE9F555-8560-4BF1-951C-8E68ED0D49E9')
, (1, @AttributeSearch, @EntityIdSearch, 0, @WorkflowTypeId, '238A7D9C-C7D0-496E-89C2-1988345A6C60')
, (1, @AttributeFamily, @EntityIdFamily, 0, @WorkflowTypeId, '09688E01-72DB-4B3D-8F73-67898AE8584D')
, (1, @AttributeActivity, @EntityIdActivity, 0, @WorkflowTypeId, '317F06EB-B6E0-4A06-B644-652490D02D63')
, (1, @AttributeConfirmation, @EntityIdConfirmation, 0, @WorkflowTypeId, '17492852-0DF8-4844-9E63-B359B16D9FB6')

/* ---------------------------------------------------------------------- */
------------------------------  END WORKFLOW ------------------------------
/* ---------------------------------------------------------------------- */

COMMIT