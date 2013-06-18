CREATE TABLE customelementset (
    xpath character varying(1000) NOT NULL
);


ALTER TABLE public.customelementset OWNER TO "www-data";

UPDATE Settings SET value='12.11' WHERE name='version';

CREATE TABLE HarvestHistory
  (
    id             int not null,
    harvestDate    varchar(30),
        harvesterUuid  varchar(250),
        harvesterName  varchar(128),
        harvesterType  varchar(128),
    deleted        char(1) default 'n' not null,
    info           text,
    params         text,

    primary key(id)

  );

CREATE INDEX HarvestHistoryNDX1 ON HarvestHistory(harvestDate);
ALTER TABLE public.harvesthistory OWNER TO "www-data";


CREATE TABLE StatusValues
  (
    id        int not null,
    name      varchar(32)   not null,
    reserved  char(1)       default 'n' not null,
    primary key(id)
  );


CREATE TABLE StatusValuesDes
  (
    idDes   int not null,
    langId  varchar(5) not null,
    label   varchar(96)   not null,
    primary key(idDes,langId)
  );


CREATE TABLE MetadataStatus
  (
    metadataId  int not null,
    statusId    int default 0 not null,
    userId      int not null,
    changeDate   varchar(30)    not null,
    changeMessage   varchar(2048) not null,
    primary key(metadataId,statusId,userId,changeDate),
    foreign key(metadataId) references Metadata(id),
    foreign key(statusId)   references StatusValues(id),
    foreign key(userId)     references Users(id)
  );
CREATE INDEX MetadataNDX3 ON Metadata(owner);
ALTER TABLE public.metadatastatus OWNER TO "www-data";

CREATE TABLE requests
(
  id integer NOT NULL,
  requestdate character varying(30),
  ip character varying(128),
  query character varying(4000),
  hits integer,
  lang character varying(16),
  sortby character varying(128),
  spatialfilter character varying(4000),
  type character varying(4000),
  simple integer DEFAULT 1,
  autogenerated integer DEFAULT 0,
  service character varying(128),
  CONSTRAINT requests_pkey PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE requests
  OWNER TO "www-data";

CREATE INDEX requestsndx1
  ON requests
  USING btree
  (requestdate);

CREATE INDEX requestsndx2
  ON requests
  USING btree
  (ip);

CREATE INDEX requestsndx3
  ON requests
  USING btree
  (hits );

CREATE INDEX requestsndx4
  ON requests
  USING btree
  (lang);

CREATE TABLE params
(
  id integer NOT NULL,
  requestid integer,
  querytype character varying(128),
  termfield character varying(128),
  termtext character varying(128),
  similarity double precision,
  lowertext character varying(128),
  uppertext character varying(128),
  inclusive character(1),
  CONSTRAINT params_pkey PRIMARY KEY (id ),
  CONSTRAINT params_requestid_fkey FOREIGN KEY (requestid)
      REFERENCES requests (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.params OWNER TO "www-data";

CREATE INDEX paramsndx1
  ON params
  USING btree
  (requestid );

CREATE INDEX paramsndx2
  ON params
  USING btree
  (querytype);

CREATE INDEX paramsndx3
  ON params
  USING btree
  (termfield);

CREATE INDEX paramsndx4
  ON params
  USING btree
  (termtext);








ALTER TABLE public.requests OWNER TO "www-data";

-- DROP TABLE shared_contacts
-- < CREATE TABLE shared_contacts (
-- <     shared_contacts_fid integer NOT NULL,
-- <     the_geom geometry,
-- <     id integer,
-- <     data text,
-- <     search text,
-- <     CONSTRAINT enforce_dims_the_geom CHECK ((ndims(the_geom) = 2)),
-- <     CONSTRAINT enforce_srid_the_geom CHECK ((srid(the_geom) = 4326))

--  DROP SEQUENCE
-- < CREATE SEQUENCE shared_contacts_shared_contacts_fid_seq
-- <     START WITH 1
-- <     INCREMENT BY 1
-- <     NO MINVALUE
-- <     NO MAXVALUE
-- <     CACHE 1;

CREATE TABLE Validation
  (
    metadataId   int,
    valType      varchar(40),
    status       int,
    tested       int,
    failed       int,
    valDate      varchar(30),
    
    primary key(metadataId, valType),
    foreign key(metadataId) references Metadata(id)
);
ALTER TABLE public.validation OWNER TO "www-data";

CREATE TABLE Thesaurus (
    id   varchar(250) not null,
    activated    varchar(1),
    primary key(id)
  );


ALTER TABLE public.thesaurus OWNER TO "www-data";

ALTER TABLE Languages ADD isocode varchar(3);
ALTER TABLE Languages ADD isInspire char(1);
ALTER TABLE Languages ADD isDefault char(1);


UPDATE Languages SET isocode = 'eng' where id ='en';
UPDATE Languages SET isocode = 'fre' where id ='fr';
UPDATE Languages SET isocode = 'esp' where id ='es';
UPDATE Languages SET isocode = 'rus' where id ='ru';
UPDATE Languages SET isocode = 'chi' where id ='cn';
UPDATE Languages SET isocode = 'ger' where id ='de';
UPDATE Languages SET isocode = 'dut' where id ='nl';
UPDATE Languages SET isocode = 'por' where id ='pt';
UPDATE Languages SET isocode = 'spa' where id ='es';

UPDATE Languages SET isInspire = 'y', isDefault = 'y' where id ='en';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='fr';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='es';
UPDATE Languages SET isInspire = 'n', isDefault = 'n' where id ='ru';
UPDATE Languages SET isInspire = 'n', isDefault = 'n' where id ='cn';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='de';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='nl';
UPDATE Languages SET isInspire = 'y', isDefault = 'n' where id ='pt';

ALTER TABLE CswServerCapabilitiesInfo ALTER COLUMN label TYPE text;


INSERT INTO Settings VALUES (23,20,'protocol','http');
INSERT INTO Settings VALUES (113,87,'group',NULL);
INSERT INTO Settings VALUES (178,173,'group',NULL);
INSERT INTO Settings VALUES (179,170,'defaultGroup', NULL);
INSERT INTO Settings VALUES (250,1,'searchStats',NULL);
INSERT INTO Settings VALUES (251,250,'enable','false');
INSERT INTO Settings VALUES (900,1,'harvester',NULL);
INSERT INTO Settings VALUES (901,900,'enableEditing','false');
INSERT INTO Settings VALUES (722,720,'enableSearchPanel','false');
INSERT INTO Settings VALUES (910,1,'metadata',NULL);
INSERT INTO Settings VALUES (911,910,'enableSimpleView','true');
INSERT INTO Settings VALUES (912,910,'enableIsoView','true');
INSERT INTO Settings VALUES (913,910,'enableInspireView','false');
INSERT INTO Settings VALUES (914,910,'enableXmlView','true');
INSERT INTO Settings VALUES (915,910,'defaultView','simple');
INSERT INTO Settings VALUES (917,1,'metadataprivs',NULL);
INSERT INTO Settings VALUES (918,917,'usergrouponly','false');
INSERT INTO Settings VALUES (920,1,'threadedindexing',NULL);
INSERT INTO Settings VALUES (921,920,'maxthreads','1');
INSERT INTO Settings VALUES (17,10,'svnUuid','');
INSERT INTO Settings VALUES (180,173,'organizationName',NULL);
INSERT INTO Settings VALUES (181,173,'postalAddress',NULL);
INSERT INTO Settings VALUES (182,173,'phone',NULL);
INSERT INTO Settings VALUES (183,173,'email',NULL);
INSERT INTO Settings VALUES (184,173,'fullName',NULL);
INSERT INTO Settings VALUES (950,1,'autodetect',NULL);
INSERT INTO Settings VALUES (951,950,'enable','true');
INSERT INTO Settings VALUES (952,1,'requestedLanguage',NULL);
INSERT INTO Settings VALUES (953,952,'only','false');
INSERT INTO Settings VALUES (954,952,'sorted','true');
INSERT INTO Settings VALUES (955,952,'ignored','false');


ALTER TABLE Users ALTER COLUMN username TYPE varchar(256);

ALTER TABLE Metadata ALTER COLUMN createDate TYPE varchar(30);
ALTER TABLE Metadata ALTER COLUMN changeDate TYPE varchar(30);
ALTER TABLE Metadata ADD doctype varchar(255);


INSERT INTO Languages VALUES ('ara','العربية', 'ara','n', 'n');
INSERT INTO Languages VALUES ('cat','Català', 'cat','n', 'n');
INSERT INTO Languages VALUES ('chi','中文', 'chi','n', 'n');
INSERT INTO Languages VALUES ('dut','Nederlands', 'dut','y', 'n');
INSERT INTO Languages VALUES ('eng','English', 'eng','y', 'y');
INSERT INTO Languages VALUES ('fin','Suomi', 'fin','y', 'n');
INSERT INTO Languages VALUES ('fre','Français', 'fre','y', 'n');
INSERT INTO Languages VALUES ('ger','Deutsch', 'ger','y', 'n');
INSERT INTO Languages VALUES ('nor','Norsk', 'nor','n', 'n');
INSERT INTO Languages VALUES ('por','Português', 'por','y', 'n');
INSERT INTO Languages VALUES ('rus','русский язык', 'rus','n', 'n');
INSERT INTO Languages VALUES ('spa','Español', 'spa','y', 'n');
INSERT INTO Languages VALUES ('vie','Tiếng Việt', 'vie','n', 'n');

UPDATE CategoriesDes SET langid='ara' WHERE langid='ar';
UPDATE CategoriesDes SET langid='cat' WHERE langid='ca';
UPDATE CategoriesDes SET langid='chi' WHERE langid='cn';
UPDATE CategoriesDes SET langid='dut' WHERE langid='nl';
UPDATE CategoriesDes SET langid='eng' WHERE langid='en';
UPDATE CategoriesDes SET langid='fin' WHERE langid='fi';
UPDATE CategoriesDes SET langid='fre' WHERE langid='fr';
UPDATE CategoriesDes SET langid='ger' WHERE langid='de';
UPDATE CategoriesDes SET langid='nor' WHERE langid='no';
UPDATE CategoriesDes SET langid='por' WHERE langid='pt';
UPDATE CategoriesDes SET langid='rus' WHERE langid='ru';
UPDATE CategoriesDes SET langid='spa' WHERE langid='es';
UPDATE CategoriesDes SET langid='vie' WHERE langid='vi';

UPDATE IsoLanguagesDes SET langid='ara' WHERE langid='ar';
UPDATE IsoLanguagesDes SET langid='cat' WHERE langid='ca';
UPDATE IsoLanguagesDes SET langid='chi' WHERE langid='cn';
UPDATE IsoLanguagesDes SET langid='dut' WHERE langid='nl';
UPDATE IsoLanguagesDes SET langid='eng' WHERE langid='en';
UPDATE IsoLanguagesDes SET langid='fin' WHERE langid='fi';
UPDATE IsoLanguagesDes SET langid='fre' WHERE langid='fr';
UPDATE IsoLanguagesDes SET langid='ger' WHERE langid='de';
UPDATE IsoLanguagesDes SET langid='nor' WHERE langid='no';
UPDATE IsoLanguagesDes SET langid='por' WHERE langid='pt';
UPDATE IsoLanguagesDes SET langid='rus' WHERE langid='ru';
UPDATE IsoLanguagesDes SET langid='spa' WHERE langid='es';
UPDATE IsoLanguagesDes SET langid='vie' WHERE langid='vi';

UPDATE RegionsDes SET langid='ara' WHERE langid='ar';
UPDATE RegionsDes SET langid='cat' WHERE langid='ca';
UPDATE RegionsDes SET langid='chi' WHERE langid='cn';
UPDATE RegionsDes SET langid='dut' WHERE langid='nl';
UPDATE RegionsDes SET langid='eng' WHERE langid='en';
UPDATE RegionsDes SET langid='fin' WHERE langid='fi';
UPDATE RegionsDes SET langid='fre' WHERE langid='fr';
UPDATE RegionsDes SET langid='ger' WHERE langid='de';
UPDATE RegionsDes SET langid='nor' WHERE langid='no';
UPDATE RegionsDes SET langid='por' WHERE langid='pt';
UPDATE RegionsDes SET langid='rus' WHERE langid='ru';
UPDATE RegionsDes SET langid='spa' WHERE langid='es';
UPDATE RegionsDes SET langid='vie' WHERE langid='vi';


UPDATE GroupsDes SET langid='ara' WHERE langid='ar';
UPDATE GroupsDes SET langid='cat' WHERE langid='ca';
UPDATE GroupsDes SET langid='chi' WHERE langid='cn';
UPDATE GroupsDes SET langid='dut' WHERE langid='nl';
UPDATE GroupsDes SET langid='eng' WHERE langid='en';
UPDATE GroupsDes SET langid='fin' WHERE langid='fi';
UPDATE GroupsDes SET langid='fre' WHERE langid='fr';
UPDATE GroupsDes SET langid='ger' WHERE langid='de';
UPDATE GroupsDes SET langid='nor' WHERE langid='no';
UPDATE GroupsDes SET langid='por' WHERE langid='pt';
UPDATE GroupsDes SET langid='rus' WHERE langid='ru';
UPDATE GroupsDes SET langid='spa' WHERE langid='es';
UPDATE GroupsDes SET langid='vie' WHERE langid='vi';


UPDATE OperationsDes SET langid='ara' WHERE langid='ar';
UPDATE OperationsDes SET langid='cat' WHERE langid='ca';
UPDATE OperationsDes SET langid='chi' WHERE langid='cn';
UPDATE OperationsDes SET langid='dut' WHERE langid='nl';
UPDATE OperationsDes SET langid='eng' WHERE langid='en';
UPDATE OperationsDes SET langid='fin' WHERE langid='fi';
UPDATE OperationsDes SET langid='fre' WHERE langid='fr';
UPDATE OperationsDes SET langid='ger' WHERE langid='de';
UPDATE OperationsDes SET langid='nor' WHERE langid='no';
UPDATE OperationsDes SET langid='por' WHERE langid='pt';
UPDATE OperationsDes SET langid='rus' WHERE langid='ru';
UPDATE OperationsDes SET langid='spa' WHERE langid='es';
UPDATE OperationsDes SET langid='vie' WHERE langid='vi';


UPDATE StatusValuesDes SET langid='ara' WHERE langid='ar';
UPDATE StatusValuesDes SET langid='cat' WHERE langid='ca';
UPDATE StatusValuesDes SET langid='chi' WHERE langid='cn';
UPDATE StatusValuesDes SET langid='dut' WHERE langid='nl';
UPDATE StatusValuesDes SET langid='eng' WHERE langid='en';
UPDATE StatusValuesDes SET langid='fin' WHERE langid='fi';
UPDATE StatusValuesDes SET langid='fre' WHERE langid='fr';
UPDATE StatusValuesDes SET langid='ger' WHERE langid='de';
UPDATE StatusValuesDes SET langid='nor' WHERE langid='no';
UPDATE StatusValuesDes SET langid='por' WHERE langid='pt';
UPDATE StatusValuesDes SET langid='rus' WHERE langid='ru';
UPDATE StatusValuesDes SET langid='spa' WHERE langid='es';
UPDATE StatusValuesDes SET langid='vie' WHERE langid='vi';


UPDATE CswServerCapabilitiesInfo SET langid='ara' WHERE langid='ar';
UPDATE CswServerCapabilitiesInfo SET langid='cat' WHERE langid='ca';
UPDATE CswServerCapabilitiesInfo SET langid='chi' WHERE langid='cn';
UPDATE CswServerCapabilitiesInfo SET langid='dut' WHERE langid='nl';
UPDATE CswServerCapabilitiesInfo SET langid='eng' WHERE langid='en';
UPDATE CswServerCapabilitiesInfo SET langid='fin' WHERE langid='fi';
UPDATE CswServerCapabilitiesInfo SET langid='fre' WHERE langid='fr';
UPDATE CswServerCapabilitiesInfo SET langid='ger' WHERE langid='de';
UPDATE CswServerCapabilitiesInfo SET langid='nor' WHERE langid='no';
UPDATE CswServerCapabilitiesInfo SET langid='por' WHERE langid='pt';
UPDATE CswServerCapabilitiesInfo SET langid='rus' WHERE langid='ru';
UPDATE CswServerCapabilitiesInfo SET langid='spa' WHERE langid='es';
UPDATE CswServerCapabilitiesInfo SET langid='vie' WHERE langid='vi';


DELETE FROM Languages WHERE id='ar';
DELETE FROM Languages WHERE id='cn';
DELETE FROM Languages WHERE id='de';
DELETE FROM Languages WHERE id='en';
DELETE FROM Languages WHERE id='es';
DELETE FROM Languages WHERE id='fr';
DELETE FROM Languages WHERE id='nl';
DELETE FROM Languages WHERE id='no';
DELETE FROM Languages WHERE id='pt';
DELETE FROM Languages WHERE id='ru';

ALTER TABLE Languages DROP COLUMN isocode;

ALTER TABLE IsoLanguages ADD shortcode varchar(2);

UPDATE IsoLanguages SET shortcode='ar' WHERE code='ara';
UPDATE IsoLanguages SET shortcode='ca' WHERE code='cat';
UPDATE IsoLanguages SET shortcode='ch' WHERE code='chi';
UPDATE IsoLanguages SET shortcode='nl' WHERE code='dut';
UPDATE IsoLanguages SET shortcode='en' WHERE code='eng';
UPDATE IsoLanguages SET shortcode='fi' WHERE code='fin';
UPDATE IsoLanguages SET shortcode='fr' WHERE code='fre';
UPDATE IsoLanguages SET shortcode='de' WHERE code='ger';
UPDATE IsoLanguages SET shortcode='no' WHERE code='nor';
UPDATE IsoLanguages SET shortcode='pt' WHERE code='por';
UPDATE IsoLanguages SET shortcode='ru' WHERE code='rus';
UPDATE IsoLanguages SET shortcode='es' WHERE code='spa';
UPDATE IsoLanguages SET shortcode='vi' WHERE code='vie';


ALTER TABLE Users ADD security varchar(128);
ALTER TABLE Users ADD authtype varchar(32);

UPDATE Users SET security='update_hash_required';

ALTER TABLE users ALTER "password" TYPE character varying(120);


UPDATE Users SET password = '46e44386069f7cf0d4f2a420b9a2383a612f316e2024b0fe84052b0b96c479a23e8a0be8b90fb8c2' WHERE username = 'admin';
UPDATE Users SET security = '' WHERE username = 'admin';

ALTER TABLE usergroups ADD profile varchar(32);
UPDATE usergroups SET profile = (SELECT profile from users WHERE id = userid);
ALTER TABLE usergroups DROP CONSTRAINT usergroups_pkey;
ALTER TABLE usergroups ADD PRIMARY KEY (userid, profile, groupid);

-- Delete LDAP settings
DELETE FROM Settings WHERE parentid=86;
DELETE FROM Settings WHERE parentid=87;
DELETE FROM Settings WHERE parentid=89;
DELETE FROM Settings WHERE parentid=80;
DELETE FROM Settings WHERE id=80;

ALTER TABLE Settings ALTER COLUMN name TYPE varchar(64);

INSERT INTO Settings VALUES (956,1,'hidewithheldelements',NULL);
INSERT INTO Settings VALUES (957,956,'enable','true');
INSERT INTO Settings VALUES (958,956,'keepMarkedElement','true');
INSERT INTO Settings VALUES (24,20,'securePort','');

UPDATE Settings SET value='2.9.0' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';

INSERT INTO StatusValues VALUES  (0,'unknown','y');
INSERT INTO StatusValues VALUES  (1,'draft','y');
INSERT INTO StatusValues VALUES  (2,'approved','y');
INSERT INTO StatusValues VALUES  (3,'retired','y');
INSERT INTO StatusValues VALUES  (4,'submitted','y');
INSERT INTO StatusValues VALUES  (5,'rejected','y');

INSERT INTO StatusValuesDes VALUES (0,'fre','Inconnu');
INSERT INTO StatusValuesDes VALUES (1,'fre','Brouillon');
INSERT INTO StatusValuesDes VALUES (2,'fre','Validé');
INSERT INTO StatusValuesDes VALUES (3,'fre','Retiré');
INSERT INTO StatusValuesDes VALUES (4,'fre','A valider');
INSERT INTO StatusValuesDes VALUES (5,'fre','Rejeté');

INSERT INTO StatusValuesDes VALUES (0,'eng','Unknown');
INSERT INTO StatusValuesDes VALUES (1,'eng','Draft');
INSERT INTO StatusValuesDes VALUES (2,'eng','Approved');
INSERT INTO StatusValuesDes VALUES (3,'eng','Retired');
INSERT INTO StatusValuesDes VALUES (4,'eng','Submitted');
INSERT INTO StatusValuesDes VALUES (5,'eng','Rejected');

ALTER TABLE Metadata ALTER harvestUri TYPE varchar(512);

ALTER TABLE HarvestHistory ADD elapsedTime int;

ALTER TABLE Users ALTER COLUMN username TYPE varchar(256);

ALTER TABLE Metadata ALTER COLUMN createDate TYPE varchar(30);
ALTER TABLE Metadata ALTER COLUMN changeDate TYPE varchar(30);

DROP TABLE IndexLanguages;

ALTER TABLE Categories ALTER COLUMN  name TYPE varchar(255);
ALTER TABLE CategoriesDes ALTER COLUMN label TYPE varchar(255);
ALTER TABLE Settings ALTER COLUMN name TYPE varchar(64);

UPDATE settings SET value='0 0 0/2 * * ?' where name = 'every';

ALTER TABLE Users ADD phone varchar(32);

create or replace function migrateSharedObjects() returns VOID as E'DECLARE
    sharedobjects record; \
    currenttime timestamp without time zone; \
    newid integer; \
    allgroupId integer; \
BEGIN
    newid = (select max(id) from metadata); \
    allgroupId = (select id from groups where name=''all''); \
    currenttime = NOW(); \

    FOR sharedobjects IN SELECT * FROM shared_contacts LOOP

        newid = newid+1; \

        INSERT INTO metadata(id,uuid,schemaid, istemplate,
            isharvested, createdate, changedate,
            data, source, root, owner, groupowner)
        VALUES ( newid, ''migrated-sharedobject-'' || newid,''iso19139'',
             ''s'',''n'', currenttime, currenttime, sharedobjects.data,''04bc362e-4e8b-48f8-888b-451a19af3a98'', ''gmd:CI_ResponsibleParty'',1,allgroupId); \

        INSERT INTO operationallowed(groupid, metadataid, operationid)
        VALUES (allgroupId,newid,0); \

        INSERT INTO operationallowed(groupid, metadataid, operationid)
        VALUES (allgroupId,newid,3); \

    END LOOP; \
END' LANGUAGE 'plpgsql';

select migrateSharedObjects();

