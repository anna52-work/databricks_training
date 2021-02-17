-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Accessing Azure Storage in Databricks
-- MAGIC There are two common ways to access Data Lake stores in Azure Databricks:
-- MAGIC 1. Mounting your storage container to the Databricks workspace to be shared by all users and clusters
-- MAGIC 2. Passing your Azure AD credentials to the storage for fine-grained access security

-- COMMAND ----------

-- MAGIC %python
-- MAGIC BLOB_CONTAINER = "blobcontainer"
-- MAGIC BLOB_ACCOUNT = "blobstor233749"
-- MAGIC ACCOUNT_KEY = "UpnVvaQylTFI6hxLmGKuQdH9GJ2aZv2B/uDzmg9Hxea9DHHO1BExrDXyadiUZf17VJfxsoGhUz/cq9Dxh91g0w=="
-- MAGIC ADLS_CONTAINER = "adlscontainer"
-- MAGIC ADLS_ACCOUNT = "adls233749"

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Mounting Azure Storage using an Access Key or Service Principal
-- MAGIC We will mount an Azure blob storage container to the workspace using a shared Access Key. More instructions can be found [here](https://docs.microsoft.com/en-us/azure/databricks/data/data-sources/azure/azure-storage#--mount-azure-blob-storage-containers-to-dbfs). 

-- COMMAND ----------

-- MAGIC %python
-- MAGIC DIRECTORY = "/"
-- MAGIC MOUNT_PATH = "/mnt/adbquickstart"
-- MAGIC 
-- MAGIC dbutils.fs.mount(
-- MAGIC   source = f"wasbs://{BLOB_CONTAINER}@{BLOB_ACCOUNT}.blob.core.windows.net",
-- MAGIC   mount_point = MOUNT_PATH,
-- MAGIC   extra_configs = {
-- MAGIC     f"fs.azure.account.key.{BLOB_ACCOUNT}.blob.core.windows.net":ACCOUNT_KEY
-- MAGIC   }
-- MAGIC )

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Once mounted, we can view and navigate the contents of our container using Databricks `%fs` file system commands.

-- COMMAND ----------

-- MAGIC %fs ls /mnt/adbquickstart/KKBox-Dataset-orig

-- COMMAND ----------

-- MAGIC %fs head /mnt/adbquickstart/KKBox-Dataset-orig/members/members_v3.csv

-- COMMAND ----------

-- MAGIC %md ### Using ADLS Credential Passthrough
-- MAGIC You can configure your Azure Databricks cluster to let you authenticate automatically to Azure Data Lake Storage Gen2 using the same Azure Active Directory (Azure AD) identity that you use to log into Azure Databricks. More information can be found [here](https://docs.microsoft.com/en-us/azure/databricks/data/data-sources/azure/azure-datalake-gen2#---access-automatically-with-your-azure-active-directory-credentials).
-- MAGIC 
-- MAGIC Here we will create our target database in an ADLS account using Credential Passthrough. 

-- COMMAND ----------

-- MAGIC %python
-- MAGIC spark.sql(f"CREATE DATABASE IF NOT EXISTS kkbox LOCATION 'abfss://{ADLS_CONTAINER}@{ADLS_ACCOUNT}.dfs.core.windows.net/kkbox'")

-- COMMAND ----------


