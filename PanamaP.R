entities <- read.csv("offshore_leaks_csvs/Entities.csv", header = TRUE)

dim(entities)
head(entities)
names(entities)
head(entities$countries, 20)

#Addresses====================
addresses <- read.csv("offshore_leaks_csvs/Addresses.csv", header = TRUE)
dim(addresses)
names(addresses)
#Intermediaries====================
intermediaries <- read.csv("offshore_leaks_csvs/Intermediaries.csv", header = TRUE)
dim(intermediaries)
names(intermediaries)
#All_edges====================
alledges <- read.csv("offshore_leaks_csvs/all_edges.csv", header = TRUE)
dim(alledges)
names(alledges)

library(stringr)
rownum <- str_detect(string = entities$countries, ignore.case("Taiwan"))

tw_ent <- entities[which(rownum == 1), ]
dim(tw_ent)
rm(entities)
names(tw_ent)

city_name <- c("Taipei County", "Taipei", "Taoyuan", "Hsinchu", "Miaoli", "Taichung", 
               "Changhua", "Yunlin", "Chiayi", "Tainan", "Kaohsiung", "Pingtung", "Yilan", 
               "Haulien", "Taitung", "Nantou", "Penghu", "Lienchiang", "Kinmen")
city_num <- list()
city_sum <- 0
for(i in 1:NROW(city_name)){
        city_num[[i]] <- str_detect(string = tw_ent$address, ignore.case(city_name[i]))
        city_sum[i] <- sum(str_detect(string = tw_ent$address, ignore.case(city_name[i])))
}
city_df <- data.frame(city_name, city_sum)
names(city_df) = c("City", "TotalComp")
city_df
sum(city_df[, 2]) == dim(tw_ent)[1]
names(city_num) <- city_name

tainan_data <- tw_ent[city_num$Tainan, ]
tainan_data

taipei_data <- tw_ent[city_num$Taipei, ]
dim(taipei_data)
taipei_data <- taipei_data[-which(str_detect(string = taipei_data$address, ignore.case("Taipei County"))), ]
names(taipei_data)
head(taipei_data[, c("jurisdiction", "jurisdiction_description")])
taipei_data <- taipei_data[, -4] #刪除管轄權
taipei_data <- taipei_data[, -15] #刪除國家代碼
table(taipei_data$sourceID)


write.csv(data.frame(Address = unique(taipei_data$address)), file = "tpeaddress.csv", row.names = FALSE)
NROW(unique(taipei_data$address))
write.csv(data.frame(Name = taipei_data$name, FormerName = taipei_data$former_name), file = "tpename.csv", row.names = FALSE)

#Officers====================

officers <- read.csv("offshore_leaks_csvs/Officers.csv", header = TRUE)
dim(officers)
head(officers)
names(officers)
tw_num <- str_detect(string = officers$country_codes, ignore.case("TWN"))
tw_off <- officers[tw_num, ]
dim(tw_off)

tw_off$name[str_detect(string = tw_off$name, ignore.case("Chou"))]
