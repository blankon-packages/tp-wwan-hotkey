# Makefile for tp-trackpoint-scroll

ACPI = /etc/acpi

all: 
	@/bin/true 

clean:
	@/bin/true 
        
install: 
	install -m 755 thinkpad-wwan.sh $(DESTDIR)/$(ACPI)/
	install -m 644 thinkpad-wwan.event $(DESTDIR)/$(ACPI)/events/thinkpad-wwan
	
        
uninstall:
	rm $(DESTDIR)/$(ACPI)/thinkpad-wwan.sh 
	rm $(DESTDIR)/$(ACPI)/events/thinkpad-wwan
