module EstormLottoGem
  class Ramalan



    def wbp_adjust_year(drawtype)
      yday=Time.now.yday()
      adj={'4d'=>0,'2d'=>6,'3d'=>3,'combo'=>9,'combo10'=>13, 'sing' => 5, 'jogu' => 7, 'shio' => 4,"pm" => 5}
      yday = yday + adj[drawtype]
      yday =yday-364 if yday > 365
      yday
    end
    
    def wbp_get_yest(draws)
      r0=r1={'digits' => "1,2,3,4,5,6"}
      r0=draws[0] if !draws[0].nil?
      r1=draws[1] if !draws[1].nil?
      yest=older='1234'
      yest=r0['digits'].split(',') if !r0['digits'].nil?
      older=r1['digits'].split(',') if !r1['digits'].nil?
      return yest,older,r0,r1
    end
    
    def draw_range(name)
      return (1..25) if name.include?("shio")
      (1..32)
    end
    
    def build_cube(name)
      [rand(draw_range(name)).to_s, rand(draw_range(name)).to_s, rand(draw_range(name)).to_s,
            rand(draw_range(name)).to_s, rand(draw_range(name)).to_s]
    end
    
    def wbp_ekor_kapala(res)
      draws=res['draws']
      yest,older,r0,r1= wbp_get_yest(draws)
      ekor= 120 - yest[-2].to_i*10 - yest[-1].to_i
      kapala= older[0].to_i*10 - yest[0].to_i*10 - yest[1].to_i + older[1].to_i
      return ekor.abs % 25 ,kapala.abs % 25 ,r0,r1
    end
    
    def build_hash(res)
      ekor,kapala,r0,r1=wbp_ekor_kapala(res)
      {ekor: ekor, kapala: kapala, r0: r0, r1: r1, shio: EstormLottoGem::Constants.shio_list.sample.last, 
            rama: build_cube('shioboot'), pastdraws: r0['drawdate']}
    end
  end #Class
end