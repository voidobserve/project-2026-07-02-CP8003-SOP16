.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ OTP_WR - BuildSet ]----------"

Project_Build:
	@make -r -f OTP_WR.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ OTP_WR - BuildSet ]----------"

