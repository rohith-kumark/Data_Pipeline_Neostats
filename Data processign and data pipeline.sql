use server_monitoring;

CREATE TABLE server_monitoring_1 (
    Server_ID CHAR(50),
    Hostname VARCHAR(100),
    IP_Address VARCHAR(50),
    OS_Type VARCHAR(50),
    Server_Location VARCHAR(100),
    CPU_Utilization FLOAT,
    Memory_Usage FLOAT,
    Disk_IO FLOAT,
    Network_Traffic_In FLOAT,
    Network_Traffic_Out FLOAT,
    Uptime_Hours INT,
    Downtime_Hours INT,
    Admin_Name VARCHAR(100),
    Admin_Email VARCHAR(100),
    Admin_Phone VARCHAR(20),
    Log_Timestamp DATETIME
);
LOAD DATA LOCAL INFILE 'E:/projects/MYSQL Server/Virtual Server Monitoring and Performance/Sample_Data_Ingestion.csv'
INTO TABLE server_monitoring_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Server_ID, Hostname, IP_Address, OS_Type, Server_Location,
 CPU_Utilization, Memory_Usage, Disk_IO, Network_Traffic_In,
 Network_Traffic_Out, Uptime_Hours, Downtime_Hours,
 Admin_Name, Admin_Email, Admin_Phone, @Log_Timestamp)
SET Log_Timestamp = STR_TO_DATE(@Log_Timestamp,'%d-%m-%Y %H:%i');
DESCRIBE server_monitoring_1;
SELECT * FROM server_monitoring_1 WHERE CPU_Utilization IS NULL OR Memory_Usage IS NULL OR Disk_IO IS NULL;
SELECT Server_ID, AVG(CPU_Utilization) AS Avg_CPU FROM server_monitoring_1 GROUP BY Server_ID;
SELECT Server_ID,AVG(Memory_Usage) AS Avg_Memory FROM server_monitoring_1 GROUP BY Server_ID;
SELECT Server_Location,AVG(CPU_Utilization) AS Avg_CPU FROM server_monitoring_1 GROUP BY Server_Location;
SELECT Server_ID,Hostname,CPU_Utilization FROM server_monitoring_1 WHERE CPU_Utilization > 80;
SELECT Server_ID,SUM(Uptime_Hours) AS Total_Uptime,SUM(Downtime_Hours) AS Total_Downtime FROM server_monitoring_1 group by Server_ID;
SELECT Server_ID,AVG(Network_Traffic_In) AS Avg_In,AVG(Network_Traffic_Out) AS Avg_Out FROM server_monitoring_1 GROUP BY Server_ID;

CREATE VIEW v_secure_monitoring AS
SELECT 
    Server_ID,
    CONCAT(
        LEFT(Admin_Email,1),
        '****',
        SUBSTRING(Admin_Email, LOCATE('@', Admin_Email))
    ) AS Protected_Email,
    SHA2(IP_Address,256) AS Protected_IP,
    CONCAT(
        'XXXXXX',
        RIGHT(Admin_Phone,4)
    ) AS Protected_Phone,
    CONCAT(
        LEFT(Admin_Name,1),
        '. ',
        SUBSTRING_INDEX(Admin_Name,' ',-1)
    ) AS Protected_Name,
    CPU_Utilization,
    Memory_Usage,
    Log_Timestamp

FROM server_monitoring_1;
SELECT * FROM v_secure_monitoring;
