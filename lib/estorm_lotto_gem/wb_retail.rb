module EstormLottoGem
  class WbRetail < EstormLottoGem::Base
    def retail_sale(src,sku,retailprice,custname="unknown",msg="wallet_retail_product")
      merge_data_perform(msg,src,{message: msg,sku: sku,retailprice: retailprice, custname: custname})   
    end
   
    def print_sales_receipt(res,seller,printer_type='adafruit')
       respstring=""
       wholesaleprice=res.first['wholesaleprice'] if res.first!=nil
       retailprice=res.first['retailprice'] if res.first!=nil
       sku=res.first['sku'] if res.first!=nil
       custname=res.first['custname'] if res.first!=nil
       txid=res[1]['txid'] if res[1]!=nil
       puts  "print sales receipt #{res} class #{res.class}"
       price=retailprice
       ['Customer Copy',"Merchant Copy"].each { |rtype|
         system("/usr/bin/python","#{self.python_directory}/print_sales_receipt.py",
                rtype,seller,price.to_s,custname,printer_type,sku,txid) if printer_type!= "none"    
                price=wholesaleprice
       }
       respstring="Sold #{sku} Retail price: #{retailprice}\nWholesale price #{wholesaleprice} to #{custname}\ntxid: #{txid}".gsub("\n","</p></p>")
       [respstring]
        
    end
    def process_invoice(src,value,invoice,msg="wallet_invoice")
      merge_data_perform(msg,src,{message: msg,value: value,invoice: invoice})   
    end
   
    def print_invoice_receipt(res,seller,printer_type='adafruit')
       respstring=""
       value=res.first['value'] if res.first!=nil
       sku=test
       invoice=res.first['invoice'] if res.first!=nil
       txid=res[1]['txid'] if res[1]!=nil
       puts  "print sales receipt #{res} class #{res.class}"
       price=retailprice
       ['MD Copy',"Delivery Copy"].each { |rtype|
         system("/usr/bin/python","#{self.python_directory}/print_sales_receipt.py",
                rtype,seller,value.to_s,invoice.to_s,printer_type,sku,txid) if printer_type!= "none"    
       }
       respstring="Invoice value: #{value} Invice number: #{invoice} to #{custname} txid: #{txid}".gsub("\n","</p></p>")
       [respstring]
        
    end
  end # clase
end #module