--Cleaning data in SQL
USE PortfolioProjects
SELECT * FROM dbo.NashvilleHousing

--Standardize date format
SELECT SaleDate FROM dbo.NashvilleHousing


ALTER TABLE dbo.NashvilleHousing
	ADD Modified_Sales_Date DATE

UPDATE dbo.NashvilleHousing
SET Modified_Sales_Date= CONVERT(DATE, SaleDate)

SELECT Modified_Sales_Date FROM dbo.NashvilleHousing


--Populate propert Address data

SELECT * FROM dbo.NashvilleHousing
ORDER BY ParcelID

SELECT a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID, ISNULL(a.PropertyAddress,b.PropertyAddress)  FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET a.PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



--Breaking out address into different columns(Address, City)

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1), SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
	ADD Property_split_Address NVARCHAR(255)

UPDATE dbo.NashvilleHousing
SET Property_split_Address= SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE dbo.NashvilleHousing
	ADD Property_split_City NVARCHAR(255)

UPDATE dbo.NashvilleHousing
SET Property_split_City= SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


--Owner Address
SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2) ,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
	ADD Owner_split_Address NVARCHAR(255)

UPDATE dbo.NashvilleHousing
SET Owner_split_Address= PARSENAME(REPLACE(OwnerAddress,',','.'),3) 

ALTER TABLE dbo.NashvilleHousing
	ADD Owner_split_City NVARCHAR(255)

UPDATE dbo.NashvilleHousing
SET Owner_split_City=  PARSENAME(REPLACE(OwnerAddress,',','.'),2) 


ALTER TABLE dbo.NashvilleHousing
	ADD Owner_split_State NVARCHAR(255)

UPDATE dbo.NashvilleHousing
SET Owner_split_State= PARSENAME(REPLACE(OwnerAddress,',','.'),1) 



--Change 'Y' and 'N' in SolaAsVacant field to 'Yes' and 'No'

SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant='Y' THEN 'Yes'
     WHEN SoldAsVacant='N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM dbo.NashvilleHousing


UPDATE dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'Yes'
     WHEN SoldAsVacant='N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM dbo.NashvilleHousing


SELECT SoldAsVacant, COUNT(SoldAsVacant) FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant

SELECT * FROM dbo.NashvilleHousing

--Remove duplicates
WITH RowNumCte AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY
                                ParcelID,
								PropertyAddress,
								SaleDate,
								SalePrice, 
								LegalReference 
								ORDER BY [UniqueID ]) row_num 
FROM dbo.NashvilleHousing)
SELECT * FROM RowNumCte
WHERE row_num>=2


WITH RowNumCte AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY
                                ParcelID,
								PropertyAddress,
								SaleDate,
								SalePrice, 
								LegalReference 
								ORDER BY [UniqueID ]) row_num 
FROM dbo.NashvilleHousing)
DELETE FROM RowNumCte
WHERE row_num>=2


--REMOVE columns
SELECT * FROM NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress











