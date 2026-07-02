.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ ledc - BuildSet ]----------"

Project_Build:
	@make -r -f ledc.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ ledc - BuildSet ]----------"

