.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ pwm - BuildSet ]----------"

Project_Build:
	@make -r -f pwm.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ pwm - BuildSet ]----------"

