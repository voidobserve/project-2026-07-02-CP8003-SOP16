.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ iic - BuildSet ]----------"

Project_Build:
	@make -r -f iic.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ iic - BuildSet ]----------"

