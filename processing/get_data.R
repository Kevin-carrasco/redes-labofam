pacman::p_load(formr, dplyr, httr, purrr, writexl, readr)

formr_connect("kevin.carrasco@ug.uchile.cl", "k959371343") #use API to connect to formr

redes_v1 <- formr_raw_results("redes1")
redes_v2 <- formr_raw_results("redes2")
redes_v3 <- formr_raw_results("redes3")


redes <- reduce(
  list(
    select(redes_v1, -modified, -ended, -expired), 
    select(redes_v2, -session_id, -study_id, -iteration, -created, -ended, -expired),
    select(redes_v3, -session_id, -study_id, -iteration, -created, -expired)
  ),
  left_join,
  by = "session"
)


redes <- redes %>%
  mutate(created = as.POSIXct(created))

redes <- redes %>%
  filter(created >= as.POSIXct("2026-05-01 00:00:00"))

redes <- redes %>% filter(!is.na(ended) & !is.na(id_entrevistado))
redes <- redes %>% filter(id_entrevistado != 123 & id_entrevistado != 1234 & id_entrevistado != 22222222 & id_entrevistado != 22222 & id_entrevistado !=19964813)

sjmisc::frq(redes$contact190)

survey <- read_csv("input/survey.csv")
orden_vars <- survey$name
redes <- redes %>% 
  select(any_of(orden_vars), everything()) %>%
  select(-session, -modified.x, -modified.y, -person2, -person,
         -person_name01, -person_name02, -person_name03, -person_name04, -person_name05,
         -person_name06, -person_name07, -person_name08, -person_name09, -person_name10,
         -person_name11, -person_name12, -person_name13, -person_name14, -person_name15,
         -person_name16, -person_name17, -person_name18, -person_name19, -person_name20)


writexl::write_xlsx(redes, "redes 09-02.xlsx")
save(redes, file="input/data/proc/redes 2026-09-02.RData")

#load("input/data/proc/redes 2026-07-02.RData")
