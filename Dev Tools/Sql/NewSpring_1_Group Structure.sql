/* ====================================================== */
-- NewSpring Script #1: 
-- Inserts campuses, groups, grouptypes and locations.

-- Make sure you're using the right Rock database:

USE [Rock]

/* ====================================================== */

declare @isSystem bit = 0
declare @delimiter varchar(5) = ' - '

update [group] set campusId = null
delete from Campus where id = 1

/* ====================================================== */
-- create campuses structure
/* ====================================================== */

insert Campus (IsSystem, Name, ShortCode, [Guid], IsActive)
values
(@isSystem, 'Anderson', 'AND', NEWID(), 1),
(@isSystem, 'Boiling Springs', 'BSP', NEWID(), 1),
(@isSystem, 'Charleston', 'CHS', NEWID(), 1),
(@isSystem, 'Columbia', 'COL', NEWID(), 1),
(@isSystem, 'Florence', 'FLO', NEWID(), 1),
(@isSystem, 'Greenville', 'GVL', NEWID(), 1),
(@isSystem, 'Greenwood', 'GWD', NEWID(), 1),
(@isSystem, 'Lexington', 'LEX', NEWID(), 1),
(@isSystem, 'Myrtle Beach', 'MYR', NEWID(), 1),
(@isSystem, 'Powdersville', 'POW', NEWID(), 1),
(@isSystem, 'Spartanburg', 'SPA', NEWID(), 1)


/* ====================================================== */
-- top check-in areas
/* ====================================================== */
if object_id('tempdb..#topAreas') is not null
begin
	drop table #topAreas
end
create table #topAreas (
	ID int IDENTITY(1,1),
	name varchar(255),
	attendanceRule int,
	inheritedType int
)

insert #topAreas
values
('Creativity & Tech Attendee', 0, 15),
('Creativity & Tech Volunteer', 2, 15),
('Fuse Attendee', 1, 17),
('Fuse Volunteer', 2, 15),
('Guest Services Attendee', 0, 15),
('Guest Services Volunteer', 2, 15),
('KidSpring Attendee', 0, null),
('KidSpring Volunteer', 2, null),
('Next Steps Attendee', 0, 15),
('Next Steps Volunteer', 2, 15)


/* ====================================================== */
-- kids structure
/* ====================================================== */
DECLARE @SpecialNeedsGroupId INT
DECLARE @SpecialNeedsGroupTypeId INT = (
	SELECT [Id]
	FROM [GroupType]
	WHERE [Name] = 'Check in By Special Needs'
	--WHERE [Guid] = '2CB16E13-141F-419F-BACD-8283AB6B3299'
);

INSERT [Attribute] ( [IsSystem],[FieldTypeId],[EntityTypeId],[EntityTypeQualifierColumn],[EntityTypeQualifierValue],[Key],[Name],[Description],[Order],[IsGridColumn],[DefaultValue],[IsMultiValue],[IsRequired],[Guid]) 
VALUES ( 0,
	(SELECT [Id] FROM [FieldType] WHERE [Name] = 'Boolean'),
	(SELECT [Id] FROM [EntityType] WHERE [Name] = 'Rock.Model.Group'),
	'GroupTypeId',
	@SpecialNeedsGroupTypeId,
	'IsSpecialNeeds',
	'Is Special Needs',
	'Indicates if this group caters to those who have special needs.',
	0,
	0,
	'False',
	0,
	0,
	NEWID()
);

SET @SpecialNeedsGroupId = SCOPE_IDENTITY()

if object_id('tempdb..#subKidAreas') is not null
begin
	drop table #subKidAreas
end
create table #subKidAreas (
	ID int IDENTITY(1,1),
	name varchar(255),
	parentName varchar(255),
	inheritedType int
)

-- Check-in Area, GroupType, Inherited Type
insert #subKidAreas
values
('Nursery', 'KidSpring Attendee', 15),
('Preschool', 'KidSpring Attendee', 15),
('Elementary', 'KidSpring Attendee', 17),
('Special Needs', 'KidSpring Attendee', @SpecialNeedsGroupTypeId),
('Nursery Vols', 'KidSpring Volunteer', 15),
('Preschool Vols', 'KidSpring Volunteer', 15),
('Elementary Vols', 'KidSpring Volunteer', 15),
('Special Needs Vols', 'KidSpring Volunteer', 15),
('KS Support Vols', 'KidSpring Volunteer', 15),
('KS Production Vols', 'KidSpring Volunteer', 15)

/* ====================================================== */
-- group structure
/* ====================================================== */
if object_id('tempdb..#groupStructure') is not null
begin
	drop table #groupStructure
end
create table #groupStructure (
	ID int IDENTITY(1,1),
	groupTypeName varchar(255),
	groupName varchar(255),
	locationName varchar(255),
)

-- GroupType, Group, Location
insert #groupStructure
values
-- kid structure from AND
('Elementary', 'Base Camp', 'Base Camp'),
('Elementary', 'ImagiNation - 1st', 'ImagiNation'),
('Elementary', 'ImagiNation - K', 'ImagiNation'),
('Elementary', 'Jump Street - 2nd', 'Jump Street'),
('Elementary', 'Jump Street - 3rd', 'Jump Street'),
('Elementary', 'Shockwave - 4th', 'Shockwave'),
('Elementary', 'Shockwave - 5th', 'Shockwave'),
('Nursery', 'Wonder Way - 1', 'Wonder Way - 1'),
('Nursery', 'Wonder Way - 2', 'Wonder Way - 2'),
('Nursery', 'Wonder Way - 3', 'Wonder Way - 3'),
('Nursery', 'Wonder Way - 4', 'Wonder Way - 4'),
('Nursery', 'Wonder Way - 5', 'Wonder Way - 5'),
('Nursery', 'Wonder Way - 6', 'Wonder Way - 6'),
('Nursery', 'Wonder Way - 7', 'Wonder Way - 7'),
('Nursery', 'Wonder Way - 8', 'Wonder Way - 8'),
('Preschool', 'Base Camp Jr.', 'Base Camp Jr.'),
('Preschool', 'Fire Station', 'Fire Station'),
('Preschool', 'Lil'' Spring', 'Lil'' Spring'),
('Preschool', 'Police', 'Police'),
('Preschool', 'Pop''s Garage', 'Pop''s Garage'),
('Preschool', 'Spring Fresh', 'Spring Fresh'),
('Preschool', 'Toys', 'Toys'),
('Preschool', 'Treehouse', 'Treehouse'),
('Special Needs', 'Spring Zone Jr.', 'Spring Zone Jr.'),
('Special Needs', 'Spring Zone', 'Spring Zone'),

-- vol structure from COL
('Creativity & Tech Attendee', 'Choir', 'Creativity & Tech Attendee'),
('Creativity & Tech Attendee', 'Special Event Attendee', 'Creativity & Tech Attendee'),
('Creativity & Tech Volunteer', 'Band Green Room', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'Band', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'IT Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'Load In / Load Out', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'New Serve Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'Office Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'Production Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'Social Media / PR Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'Special Event Volunteer', 'Creativity & Tech Volunteer'),
('Elementary Vols', 'Base Camp Volunteer', 'Base Camp'),
('Elementary Vols', 'Base Camp Team Leader', 'Base Camp'),
('Elementary Vols', 'Early Bird Volunteer', 'Elementary Volunteer'),
('Elementary Vols', 'Elementary Service Leader', 'Elementary Volunteer'),
('Elementary Vols', 'Elementary Area Leader', 'Elementary Volunteer'),
('Elementary Vols', 'ImagiNation Volunteer', 'ImagiNation'),
('Elementary Vols', 'ImagiNation Team Leader', 'ImagiNation'),
('Elementary Vols', 'Jump Street Volunteer', 'Jump Street'),
('Elementary Vols', 'Jump Street Team Leader', 'Jump Street'),
('Elementary Vols', 'Shockwave Volunteer', 'Shockwave'),
('Elementary Vols', 'Shockwave Team Leader', 'Shockwave'),
('Fuse Attendee', '10th Grade Student', 'Fuse Attendee'),
('Fuse Attendee', '11th Grade Student', 'Fuse Attendee'),
('Fuse Attendee', '12th Grade Student', 'Fuse Attendee'),
('Fuse Attendee', '6th Grade Student', 'Fuse Attendee'),
('Fuse Attendee', '7th Grade Student', 'Fuse Attendee'),
('Fuse Attendee', '8th Grade Student', 'Fuse Attendee'),
('Fuse Attendee', '9th Grade Student', 'Fuse Attendee'),
('Fuse Volunteer', 'Atrium', 'Fuse Volunteer'),
('Fuse Volunteer', 'Campus Safety', 'Fuse Volunteer'),
('Fuse Volunteer', 'Care Team', 'Fuse Volunteer'),
('Fuse Volunteer', 'Check-In', 'Fuse Volunteer'),
('Fuse Volunteer', 'Fuse Group Leader', 'Fuse Volunteer'),
('Fuse Volunteer', 'Fuse Guest', 'Fuse Volunteer'),
('Fuse Volunteer', 'Game Room', 'Fuse Volunteer'),
('Fuse Volunteer', 'Greeter', 'Fuse Volunteer'),
('Fuse Volunteer', 'Jump Off', 'Fuse Volunteer'),
('Fuse Volunteer', 'Leadership Team', 'Fuse Volunteer'),
('Fuse Volunteer', 'Load In / Load Out', 'Fuse Volunteer'),
('Fuse Volunteer', 'Lounge', 'Fuse Volunteer'),
('Fuse Volunteer', 'New Serve Team', 'Fuse Volunteer'),
('Fuse Volunteer', 'Next Steps Area', 'Fuse Volunteer'),
('Fuse Volunteer', 'Office Team', 'Fuse Volunteer'),
('Fuse Volunteer', 'Parking', 'Fuse Volunteer'),
('Fuse Volunteer', 'Pick-Up', 'Fuse Volunteer'),
('Fuse Volunteer', 'Production', 'Fuse Volunteer'),
('Fuse Volunteer', 'Snack Bar', 'Fuse Volunteer'),
('Fuse Volunteer', 'Special Event Volunteer', 'Fuse Volunteer'),
('Fuse Volunteer', 'Sports', 'Fuse Volunteer'),
('Fuse Volunteer', 'Spring Zone', 'Fuse Volunteer'),
('Fuse Volunteer', 'Student Leader', 'Fuse Volunteer'),
('Fuse Volunteer', 'Sunday Fuse Team', 'Fuse Volunteer'),
('Fuse Volunteer', 'Ushers', 'Fuse Volunteer'),
('Fuse Volunteer', 'VHQ', 'Fuse Volunteer'),
('Fuse Volunteer', 'Worship', 'Fuse Volunteer'),
('Guest Services Attendee', 'Green Room Attendee', 'Guest Services Attendee'),
('Guest Services Attendee', 'Special Event Attendee', 'Guest Services Attendee'),
('Guest Services Volunteer', 'Auditorium Reset Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Awake Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Campus Safety', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Facilities Volunteer', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Facility Cleaning Crew', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Finance Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Green Room Volunteer', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Greeting Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Guest Services Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Load In / Load Out', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'New Serve Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Office Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Parking Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Service Coordinator', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Sign Language Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Special Event Volunteer', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'Usher Team', 'Guest Services Volunteer'),
('Guest Services Volunteer', 'VHQ Team', 'Guest Services Volunteer'),
('KS Production Vols', 'Elementary Production Area Leader', 'Production Volunteer'),
('KS Production Vols', 'Elementary Production Service Leader', 'Production Volunteer'),
('KS Production Vols', 'Elementary Actor', 'Production Volunteer'),
('KS Production Vols', 'Preschool Production Area Leader', 'Production Volunteer'),
('KS Production Vols', 'Preschool Production Service Leader', 'Production Volunteer'),
('KS Production Vols', 'Preschool Actor', 'Production Volunteer'),
('KS Production Vols', 'Elementary Media', 'Production Volunteer'),
('KS Production Vols', 'Preschool Media', 'Production Volunteer'),
('KS Production Vols', 'Elementary Worship Leader', 'Production Volunteer'),
('KS Support Vols', 'Advocate', 'Support Volunteer'),
('KS Support Vols', 'Advocate Team Leader', 'Support Volunteer'),
('KS Support Vols', 'Assistant', 'Support Volunteer'),
('KS Support Vols', 'Check-In Volunteer', 'Support Volunteer'),
('KS Support Vols', 'Check-In Team Leader', 'Support Volunteer'),
('KS Support Vols', 'First Time Team Volunteer', 'Support Volunteer'),
('KS Support Vols', 'First Time Team Leader', 'Support Volunteer'),
('KS Support Vols', 'Greeter', 'Support Volunteer'),
('KS Support Vols', 'Greeter Team Leader', 'Support Volunteer'),
('KS Support Vols', 'Guest Services Service Leader', 'Support Volunteer'),
('KS Support Vols', 'Guest Services Area Leader', 'Support Volunteer'),
('KS Support Vols', 'Office Team', 'Support Volunteer'),
('KS Support Vols', 'Load In / Load Out', 'Support Volunteer'),
('KS Support Vols', 'New Serve Team Volunteer', 'Support Volunteer'),
('KS Support Vols', 'New Serve Area Leader', 'Support Volunteer'),
('KS Support Vols', 'New Serve Service Leader', 'Support Volunteer'),
('KS Support Vols', 'Trainer', 'Support Volunteer'),
('Next Steps Attendee', 'Baptism Attendee', 'Next Steps Attendee'),
('Next Steps Attendee', 'Creativity & Tech Basics', 'Next Steps Attendee'),
('Next Steps Attendee', 'Creativity & Tech First Look', 'Next Steps Attendee'),
('Next Steps Attendee', 'Creativity & Tech First Serve', 'Next Steps Attendee'),
('Next Steps Attendee', 'Financial Coaching Attendee', 'Next Steps Attendee'),
('Next Steps Attendee', 'Fuse Basics', 'Next Steps Attendee'),
('Next Steps Attendee', 'Fuse First Look', 'Next Steps Attendee'),
('Next Steps Attendee', 'Fuse First Serve', 'Next Steps Attendee'),
('Next Steps Attendee', 'Guest Services Basics', 'Next Steps Attendee'),
('Next Steps Attendee', 'Guest Services First Look', 'Next Steps Attendee'),
('Next Steps Attendee', 'Guest Services First Serve', 'Next Steps Attendee'),
('Next Steps Attendee', 'KidSpring Basics', 'Next Steps Attendee'),
('Next Steps Attendee', 'KidSpring First Look', 'Next Steps Attendee'),
('Next Steps Attendee', 'KidSpring First Serve', 'Next Steps Attendee'),
('Next Steps Attendee', 'Next Steps Basics', 'Next Steps Attendee'),
('Next Steps Attendee', 'Next Steps First Look', 'Next Steps Attendee'),
('Next Steps Attendee', 'Next Steps First Serve', 'Next Steps Attendee'),
('Next Steps Attendee', 'Opportunities Tour', 'Next Steps Attendee'),
('Next Steps Attendee', 'Ownership Class Attendee', 'Next Steps Attendee'),
('Next Steps Attendee', 'Ownership Class Current Owner', 'Next Steps Attendee'),
('Next Steps Attendee', 'Special Event Attendee', 'Next Steps Attendee'),
('Next Steps Volunteer', 'Baptism Volunteer', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Care Office Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Care Visitation Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'District Leader', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Events Office Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Financial Coaching Volunteer', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Financial Planning Office Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Group Leader', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Group Training', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Groups Connector', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Groups Office Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Load In / Load Out', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'New Serve Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Next Steps Area', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Ownership Class Volunteer', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Prayer Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Resource Center', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Special Event Volunteer', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Sunday Care Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Writing Team', 'Next Steps Volunteer'),
('Nursery Vols', 'Early Bird Volunteer', 'Nursery Volunteer'),
('Nursery Vols', 'Wonder Way Service Leader', 'Nursery Volunteer'),
('Nursery Vols', 'Wonder Way Area Leader', 'Nursery Volunteer'),
('Nursery Vols', 'Wonder Way 1 Volunteer', 'Wonder Way - 1'),
('Nursery Vols', 'Wonder Way 2 Volunteer', 'Wonder Way - 2'),
('Nursery Vols', 'Wonder Way 3 Volunteer', 'Wonder Way - 3'),
('Nursery Vols', 'Wonder Way 4 Volunteer', 'Wonder Way - 4'),
('Nursery Vols', 'Wonder Way 5 Volunteer', 'Wonder Way - 5'),
('Nursery Vols', 'Wonder Way 6 Volunteer', 'Wonder Way - 6'),
('Nursery Vols', 'Wonder Way 7 Volunteer', 'Wonder Way - 7'),
('Nursery Vols', 'Wonder Way 8 Volunteer', 'Wonder Way - 8'),
('Nursery Vols', 'Wonder Way 1 Team Leader', 'Wonder Way - 1'),
('Nursery Vols', 'Wonder Way 2 Team Leader', 'Wonder Way - 2'),
('Nursery Vols', 'Wonder Way 3 Team Leader', 'Wonder Way - 3'),
('Nursery Vols', 'Wonder Way 4 Team Leader', 'Wonder Way - 4'),
('Nursery Vols', 'Wonder Way 5 Team Leader', 'Wonder Way - 5'),
('Nursery Vols', 'Wonder Way 6 Team Leader', 'Wonder Way - 6'),
('Nursery Vols', 'Wonder Way 7 Team Leader', 'Wonder Way - 7'),
('Nursery Vols', 'Wonder Way 8 Team Leader', 'Wonder Way - 8'),
('Preschool Vols', 'Base Camp Jr. Volunteer', 'Base Camp Jr.'),
('Preschool Vols', 'Fire Station Volunteer', 'Fire Station'),
('Preschool Vols', 'Fire Station Team Leader', 'Fire Station'),
('Preschool Vols', 'Lil Spring Volunteer', 'Lil Spring'),
('Preschool Vols', 'Lil Spring Team Leader', 'Lil Spring'),
('Preschool Vols', 'Police Volunteer', 'Police'),
('Preschool Vols', 'Police Team Leader', 'Police'),
('Preschool Vols', 'Pop''s Garage Volunteer', 'Pop''s Garage'),
('Preschool Vols', 'Pop''s Garage Team Leader', 'Pop''s Garage'),
('Preschool Vols', 'Early Bird Volunteer', 'Preschool Volunteer'),
('Preschool Vols', 'Preschool Service Leader', 'Preschool Volunteer'),
('Preschool Vols', 'Preschool Area Leader', 'Preschool Volunteer'),
('Preschool Vols', 'Spring Fresh Volunteer', 'Spring Fresh'),
('Preschool Vols', 'Spring Fresh Team Leader', 'Spring Fresh'),
('Preschool Vols', 'Toys Volunteer', 'Toys'),
('Preschool Vols', 'Toys Team Leader', 'Toys'),
('Preschool Vols', 'Treehouse Volunteer', 'Treehouse'),
('Preschool Vols', 'Treehouse Team Leader', 'Treehouse'),
('Special Needs Vols', 'Spring Zone Jr. Volunteer', 'Spring Zone Jr.'),
('Special Needs Vols', 'Spring Zone Service Leader', 'Spring Zone'),
('Special Needs Vols', 'Spring Zone Area Leader', 'Spring Zone'),
('Special Needs Vols', 'Spring Zone Volunteer', 'Spring Zone')


/* ====================================================== */
-- delete existing areas
/* ====================================================== */

delete from location
where id in (
	select distinct locationId
	from grouplocation gl
	inner join [group] g
	on gl.groupid = g.id
	and g.GroupTypeId in (14, 18, 19, 20, 21, 22)
)

delete from location where id > 1

delete from GroupTypeAssociation
where GroupTypeId in (14, 18, 19, 20, 21, 22)
or ChildGroupTypeId in (14, 18, 19, 20, 21, 22)

delete from [Group]
where GroupTypeId in (14, 18, 19, 20, 21, 22)

delete from GroupType
where id in (14, 18, 19, 20, 21, 22)


/* ====================================================== */
-- set up initial values
/* ====================================================== */

declare @campusId int, @numCampuses int, @initialAreaId int, @groupRoleId int,
	@typePurpose int, @campusLocationId int, @initialGroupId int
select @typePurpose = 142  /* check-in template purpose type */
select @campusId = min(Id) from Campus
select @numCampuses = count(1) + @campusId from Campus

declare @campusName varchar(30), @code varchar(5)

/* ====================================================== */
-- insert campus levels
/* ====================================================== */
while @campusId <= @numCampuses
begin

	select @campusName = '', @initialAreaId = 0
	select @campusName = name, @code = ShortCode
	from Campus where Id = @campusId

	if @campusName <> ''
	begin
		-- campus location
		insert location (ParentLocationId, Name, IsActive, [Guid])
		select NULL, @campusName, 1, NEWID()

		set @campusLocationId = SCOPE_IDENTITY()

		update campus set LocationId = @campusLocationId where id = @campusId

		-- initial check-in areas
		insert grouptype (IsSystem, Name, Description, GroupTerm, GroupMemberTerm,
			DefaultGroupRoleId, AllowMultipleLocations, ShowInGroupList,
			ShowInNavigation, TakesAttendance, AttendanceRule, AttendancePrintTo,
			[Order], InheritedGroupTypeId, LocationSelectionMode, GroupTypePurposeValueId, [Guid],
			AllowedScheduleTypes, SendAttendanceReminder)
		select 0, @campusName, @campusName + ' Campus', 'Group', 'Member',
			NULL, 0, 1, 1, 0, 0, 1, 0, NULL, 0, 142, NEWID(), 0, 0

		select @initialAreaId = SCOPE_IDENTITY()

		/* ====================================================== */
		-- set default grouptype role
		/* ====================================================== */
		insert GroupTypeRole (isSystem, GroupTypeId, Name, [Order], IsLeader,
			[Guid], CanView, CanEdit)
		values (@isSystem, @initialAreaId, 'Member', 0, 0, NEWID(), 0, 0)

		select @groupRoleId = SCOPE_IDENTITY()

		update grouptype
		set DefaultGroupRoleId = @groupRoleId
		where id = @initialAreaId

		/* ============================== */
		-- create matching group
		/* ============================== */
		insert [Group] (IsSystem, ParentGroupId, GroupTypeId, CampusId, Name,
			Description, IsSecurityRole, IsActive, [Order], [Guid])
		select @isSystem, NULL, @initialAreaId, @campusId, @campusName,
			@campusName + ' Group', 0, 1, 0, NEWID()

		select @initialGroupId = SCOPE_IDENTITY()

		/* ====================================================== */
		-- insert top areas
		/* ====================================================== */
		declare @scopeIndex int, @numItems int, @topAreaId int,
			@attendanceRule int, @inheritedTypeId int, @baseLocationId int
		declare @areaName varchar(255), @baseLocation varchar(255)
		declare @volunteer varchar(255) = 'Volunteer'
		declare @attendee varchar(255) = 'Attendee'

		select @scopeIndex = min(Id) from #topAreas
		select @numItems = count(1) + @scopeIndex from #topAreas

		while @scopeIndex <= @numItems
		begin

			select @areaName = '', @topAreaId = 0, @groupRoleId = 0
			select @areaName = name, @attendanceRule = attendanceRule, @inheritedTypeId = inheritedType
			from #topAreas where id = @scopeIndex

			if @areaName <> ''
			begin

				/* ====================================================== */
				-- insert top area hierarchy
				/* ====================================================== */
				insert grouptype (IsSystem, Name, Description, GroupTerm, GroupMemberTerm,
					DefaultGroupRoleId, AllowMultipleLocations, ShowInGroupList,
					ShowInNavigation, TakesAttendance, AttendanceRule, AttendancePrintTo,
					[Order], InheritedGroupTypeId, LocationSelectionMode, GroupTypePurposeValueId, [Guid],
					AllowedScheduleTypes, SendAttendanceReminder)
				select 0, @code + @delimiter + @areaName, @code + @delimiter + @areaName + ' GroupType', 'Group', 'Member', NULL,
					1, 1, 1, 1, @attendanceRule, 0, 0, @inheritedTypeId, 0, NULL, NEWID(), 0, 0

				select @topAreaId = SCOPE_IDENTITY()

				insert GroupTypeAssociation
				values (@initialAreaId, @topAreaId)

				-- allow children of this grouptype
				insert GroupTypeAssociation
				values (@topAreaId, @topAreaId)

				/* ====================================================== */
				-- set default grouptype role
				/* ====================================================== */
				insert GroupTypeRole (isSystem, GroupTypeId, Name, [Order], IsLeader,
					[Guid], CanView, CanEdit)
				values (@isSystem, @topAreaId, 'Member', 0, 0, NEWID(), 0, 0)

				select @groupRoleId = SCOPE_IDENTITY()

				update grouptype
				set DefaultGroupRoleId = @groupRoleId
				where id = @topAreaId

				/* ============================== */
				-- create matching group
				/* ============================== */
				insert [Group] (IsSystem, ParentGroupId, GroupTypeId, CampusId, Name,
					Description, IsSecurityRole, IsActive, [Order], [Guid])
				select @isSystem, @initialGroupId, @topAreaId, @campusId, @areaName,
					@code + @delimiter + @areaName + ' Group', 0, 1, 0, NEWID()

				-- set up child location
				insert location (ParentLocationId, Name, IsActive, [Guid])
				select @campusLocationId, @areaName, 1, NEWID()

				select @baseLocationId = NULL, @baseLocation = ''
			end
			--end if area not empty

			set @scopeIndex = @scopeIndex + 1
		end
		-- end top area grouptypes


		/* ====================================================== */
		-- set tri level grouptypes
		/* ====================================================== */
		declare @parentArea varchar(255), @areaId int, @parentGroupId int
		select @scopeIndex = min(Id) from #subKidAreas
		select @numItems = @scopeIndex + count(1) from #subKidAreas

		while @scopeIndex <= @numItems
		begin

			select @areaName = ''
			select @areaName = name, @parentArea = parentName, @inheritedTypeId = inheritedType
			from #subKidAreas where id = @scopeIndex

			if @areaName <> ''
			begin

				select @topAreaId = Id from GroupType where name = @code + @delimiter + @parentArea

				insert grouptype (IsSystem, Name, Description, GroupTerm, GroupMemberTerm,
					DefaultGroupRoleId, AllowMultipleLocations, ShowInGroupList,
					ShowInNavigation, TakesAttendance, AttendanceRule, AttendancePrintTo,
					[Order], InheritedGroupTypeId, LocationSelectionMode, GroupTypePurposeValueId, [Guid],
					AllowedScheduleTypes, SendAttendanceReminder)
				select 0, @code + @delimiter + @areaName, @code + @delimiter + @areaName + ' GroupType', 'Group', 'Member', NULL,
					1, 1, 1, 1, 0, 0, 0, @inheritedTypeId, 0, NULL, NEWID(), 0, 0

				select @areaId = SCOPE_IDENTITY()

				insert GroupTypeAssociation
				values (@topAreaId, @areaId)

				-- allow children of this grouptype
				insert GroupTypeAssociation
				values (@areaId, @areaId)

				/* ============================== */
				-- set default grouptype role
				/* ============================== */
				insert grouptypeRole (isSystem, GroupTypeId, Name, [Order], IsLeader,
					[Guid], CanView, CanEdit)
				values (@isSystem, @areaId, 'Member', 0, 0, NEWID(), 0, 0)

				select @groupRoleId = SCOPE_IDENTITY()

				update grouptype
				set DefaultGroupRoleId = @groupRoleId
				where id = @areaId

				/* ============================== */
				-- create matching group
				/* ============================== */
				select @parentGroupId = Id from [group]
				where name = @parentArea
				and ParentGroupId = @initialGroupId

				insert [Group] (IsSystem, ParentGroupId, GroupTypeId, CampusId, Name,
					Description, IsSecurityRole, IsActive, [Order], [Guid])
				select @isSystem, @parentGroupId, @areaId, @campusId,  @areaName,
					@areaName + @delimiter + 'Group', 0, 1, 10, NEWID()

			end
			--end if area not empty

			set @scopeIndex = @scopeIndex + 1
		end
		-- end kid level grouptypes


		/* ====================================================== */
		-- set group structure
		/* ====================================================== */
		declare @groupName varchar(255), @groupTypeName varchar(255), @locationName varchar(255)
		declare @locationId int, @parentLocationId int, @groupTypeId int, @parentGroupTypeId int, @groupId int
		select @scopeIndex = min(Id) from #groupStructure
		select @numItems = @scopeIndex + count(1) from #groupStructure

		while @scopeIndex <= @numItems
		begin

			select @groupName = null, @groupTypeName = null, @locationName = null, @locationId = null
			select @groupName = groupName, @groupTypeName = groupTypeName, @locationName = locationName
			from #groupStructure where id = @scopeIndex

			if @groupName is not null
			begin
				-- get child and parent group
				select @groupTypeId = Id from grouptype
				where name = @code + @delimiter + @groupTypeName

				select @parentGroupId = Id from [group]
				where name = @groupTypeName
				and grouptypeId = @groupTypeId

				-- insert child level group
				insert [Group] (IsSystem, ParentGroupId, GroupTypeId, CampusId, Name,
					Description, IsSecurityRole, IsActive, [Order], [Guid])
				select @isSystem, @parentGroupId, @groupTypeId, @campusId, @groupName,
					@code + @delimiter + @groupName + ' Group', 0, 1, 0, NEWID()

				select @groupid = SCOPE_IDENTITY()

				-- insert location for group

				;with locationChildren as (
					select l.id, l.parentLocationId, l.name
						from location l
						where id = @campusLocationId
					union all
					select l2.id, l2.parentlocationId, l2.name
						from location l2
						inner join locationChildren lc
						on lc.id = l2.ParentLocationId
				)
				select @locationId = id from locationChildren
				where name = @locationname

				if @locationId is null
				begin

					declare @parentLocationName varchar(255)
					-- KidSpring is the only one with a tri-level setup
					if @groupTypeName like '%vols%'
					begin
						select @parentLocationName = 'KidSpring Volunteer'
					end
					else begin
						select @parentLocationName = 'KidSpring Attendee'
					end

					;with locationChildren as (
						select l.id, l.parentLocationId, l.name
							from location l
							where id = @campusLocationId
						union all
						select l2.id, l2.parentlocationId, l2.name
							from location l2
							inner join locationChildren lc
							on lc.id = l2.ParentLocationId
					)
					select @parentLocationId = id from locationChildren
					where name = @parentLocationName

					-- create location
					insert location (ParentLocationId, Name, IsActive, [Guid])
					select @parentLocationId, @locationName, 1, NEWID()

					select @locationId = SCOPE_IDENTITY()
				end

				insert grouplocation (groupid, locationid, IsMailingLocation, IsMappedLocation, [Guid])
				values (@groupid, @locationId, 0, 0, newid())
			end
			-- end group name not empty

			set @scopeIndex = @scopeIndex + 1
		end
		-- end group structure

	end
	-- end campus not empty

	set @campusId = @campusId + 1
end
-- end campuses loop

/* ====================================================== */
-- Add IsSpecialNeeds attribute value to spring zone groups
/* ====================================================== */

INSERT [AttributeValue] ( [IsSystem],[AttributeId],[EntityId],[Value] ,[Guid] ) 
SELECT 0, @SpecialNeedsGroupId, g.[Id], 'True', NEWID()
FROM [Group] g
JOIN [Group] parent ON g.ParentGroupId = parent.Id
JOIN [GroupType] parentGt ON parent.GroupTypeId = parentGt.Id
WHERE g.Name = 'Spring Zone' or g.Name = 'Spring Zone Jr.'


/* ====================================================== */
-- Add Central campus and groups since vastly different
/* ====================================================== */
insert Campus (IsSystem, Name, ShortCode, [Guid], IsActive)
values
(@isSystem, 'Central', 'CEN', NEWID(), 1)

/* ====================================================== */
-- central check-in areas
/* ====================================================== */
if object_id('tempdb..#centralAreas') is not null
begin
	drop table #centralAreas
end
create table #centralAreas (
	ID int IDENTITY(1,1),
	name varchar(255),
	attendanceRule int,
	inheritedType int
)

insert #centralAreas
values
('Creativity & Tech Volunteer', 2, 15),
('Events', 2, 15),
('Fuse Volunteer', 2, 15),
('Guest Service Volunteer', 2, 15),
('KidSpring Volunteer', 2, 15),
('Next Steps Volunteer', 2, 15)

/* ====================================================== */
-- group structure
/* ====================================================== */
if object_id('tempdb..#centralGroups') is not null
begin
	drop table #centralGroups
end
create table #centralGroups (
	ID int IDENTITY(1,1),
	groupTypeName varchar(255),
	groupName varchar(255),
	locationName varchar(255),
)

-- GroupType, Group, Location
insert #centralGroups
values
('Creativity & Tech Volunteer', 'Design Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'IT Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'NewSpring Store Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'Social Media/PR Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'Video Production Team', 'Creativity & Tech Volunteer'),
('Creativity & Tech Volunteer', 'Web Dev Team', 'Creativity & Tech Volunteer'),
('Events', 'Event Attendee', 'Events'),
('Events', 'Event Attendee', 'Events'),
('Fuse Volunteer', 'Fuse Office Team', 'Fuse Volunteer'),
('Fuse Volunteer', 'Special Event Attendee', 'Fuse Volunteer'),
('Fuse Volunteer', 'Special Event Volunteer', 'Fuse Volunteer'),
('Guest Service Volunteer', 'Events Team', 'Guest Service Volunteer'),
('Guest Service Volunteer', 'Finance Office Team', 'Guest Service Volunteer'),
('Guest Service Volunteer', 'GS Office Team', 'Guest Service Volunteer'),
('Guest Service Volunteer', 'HR Team', 'Guest Service Volunteer'),
('Guest Service Volunteer', 'Receptionist', 'Guest Service Volunteer'),
('Guest Service Volunteer', 'Special Event Attendee', 'Guest Service Volunteer'),
('Guest Service Volunteer', 'Special Event Volunteer', 'Guest Service Volunteer'),
('KidSpring Volunteer', 'KS Office Team', 'KidSpring Volunteer'),
('Next Steps Volunteer', 'Groups Office Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'NS Office Team', 'Next Steps Volunteer'),
('Next Steps Volunteer', 'Writing Team', 'Next Steps Volunteer')



/* TESTING SECTION

use master
restore database test from test with replace

use test


select '(''' + substring(c.name, 7, len(c.name)-6) + ''', '  --as 'child.grouptype'
+ '''' + g.name + ''', ' --as 'child.group'
+ '''' + l.name + '''),' --as 'group.location'
select distinct l.name
from rock..GroupType p
inner join rock..GroupTypeAssociation gta
on p.id = gta.GroupTypeId
and p.name like 'col%'
and p.name not like '%kidspring%attendee%'
inner join rock..grouptype c
on gta.ChildGroupTypeId = c.id
inner join rock..[group] g
on g.GroupTypeId = c.id
inner join rock..grouplocation gl
on g.id = gl.groupid
inner join rock..location l
on gl.LocationId = l.id


*/