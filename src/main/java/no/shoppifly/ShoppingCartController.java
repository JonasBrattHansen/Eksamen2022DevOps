package no.shoppifly;

import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController()
public class ShoppingCartController implements ApplicationListener<ApplicationReadyEvent>{

    private final Map<String, Cart> shoppingCarts = new HashMap<>();

    private MeterRegistry meterRegistry;

    @Autowired
    public ShoppingCartController(MeterRegistry meterRegistry, CartService cartService) {
        this.meterRegistry = meterRegistry;
        this.cartService = cartService;
    }

    private final CartService cartService;



    @GetMapping(path = "/cart/{id}")
    public Cart getCart(@PathVariable String id) {
        return cartService.getCart(id);
    }

    /**
     * Checks out a shopping cart. Removes the cart, and returns an order ID
     *
     * @return an order ID
     */
    @PostMapping(path = "/cart/checkout")
    public String checkout(@RequestBody Cart cart) {
        return cartService.checkout(cart);
    }

    /**
     * Updates a shopping cart, replacing it's contents if it already exists. If no cart exists (id is null)
     * a new cart is created.
     *
     * @return the updated cart
     */
    @PostMapping(path = "/cart")
    public Cart updateCart(@RequestBody Cart cart) {
        return cartService.update(cart);
    }

    /**
     * return all cart IDs
     *
     * @return
     */
    @GetMapping(path = "/carts")
    public List<String> getAllCarts() {
        return cartService.getAllsCarts();
    }

    public void onApplicationEvent(ApplicationReadyEvent applicationReadyEvent) {
        // Verdi av total
        Gauge.builder("carts_count", shoppingCarts,
                Map::size).register(meterRegistry);

        Gauge.builder("carts_value", shoppingCarts,
                        b -> b.values()
                                .stream()
                                .flatMap(c -> c.getItems().stream()
                                        .map(i -> i.getQty() * i.getUnitPrice()))
                                .mapToDouble(Float::doubleValue)
                                .sum())
                .register(meterRegistry);
    }



}